<?php 

$connection = new mysqli("localhost", "root", "", "latihan");
$title = $_POST['title'];
$content = $_POST['content'];

$result = mysqli_query($connection, "insert into note_app set title='$title', content='$content'");

    if ($result) {
        echo json_encode([
            'message' => 'Data Berhasil Disimpan'
        ]);
        
    } else {
        echo json_encode([
            'message' => 'Data Gagal Disimpan'
        ]);
    }

?>