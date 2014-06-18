<?php
//    Copyright 2014 Dave Umrysh
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
$ctx=stream_context_create(array('http'=> array( 'timeout' => 1200) )); 

$data = file_get_contents('http://blockorigin.pfoe.be/blocklist.php', false,$ctx);

$dom = new domDocument;

@$dom->loadHTML($data);
$dom->preserveWhiteSpace = false;
$tables = $dom->getElementsByTagName('table');

$rows = $tables->item(1)->getElementsByTagName('tr');

$arr = array();

foreach ($rows as $row) {
    $cols = $row->getElementsByTagName('td');
    if($cols->item(0) && $cols->item(2) && $cols->item(0)->textContent!="" && $cols->item(2)->textContent !="")
    {
        array_push($arr,array(str_replace("-","",trim($cols->item(0)->textContent)),str_replace("%","",trim($cols->item(2)->textContent)),$cols->item(1)->textContent));
    }
}

$line = '';

if(file_exists('BTCBlocks.txt'))
{
    $f = fopen('BTCBlocks.txt', 'r');
    $cursor = -1;

    fseek($f, $cursor, SEEK_END);
    $char = fgetc($f);


    // Trim trailing newline chars of the file
    while ($char === "\n" || $char === "\r") {
        fseek($f, $cursor--, SEEK_END);
        $char = fgetc($f);
    }


    // Read until the start of file or first newline char
    while ($char !== false && $char !== "\n" && $char !== "\r") {
        // Prepend the new char
        $line = $char . $line;
        fseek($f, $cursor--, SEEK_END);
        $char = fgetc($f);
    }
    fclose($f);

    $lastBlockArray = explode( "|" , $line);
    $lastBlock = trim($lastBlockArray[0]);
    if(count($lastBlockArray)>2){
        $lastBlockTime = trim($lastBlockArray[1]);
    }else{
        $lastBlockTime = 0;
    }
}else{
    $lastBlock = 0;
    $lastBlockTime = 0;
}

$f = fopen('BTCBlocks.txt', 'a');

foreach (array_reverse($arr) as $row) {
    if($row[0]>$lastBlock)
    {
        // Get time of block
        echo "Adding " . $row[0] . "\n";
        $temp = json_decode(str_replace('\"','"',file_get_contents("http://blockchain.info/rawblock/".$row[2]."?format=json", false,$ctx)));

        fwrite($f, $row[0] . " | " . $temp->time . " | " . ($temp->time-$lastBlockTime) . " | " . $row[1] . "\n");
        $lastBlockTime = $temp->time;
    }
}
fclose($f);
?>