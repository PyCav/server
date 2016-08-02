<?php
	echo nl2br( file_get_contents('/home/public/server/stats.txt') );
?>
<html>
	<head>
    	<meta http-equiv="refresh" content="5" > 
    </head>
	<body>
		<p>
			<a href="/index.php"> back </a>
		</p>
	</body>
</html>
