<head>
<script type="text/javascript">
var imgno=0;
//images=["images/test1.png", "images/test2.png", "images/test3.png"];

<?php 
	$imgdir="60x60_og_40x60/";
	$mystring="images=["; 
	$path    = "/home/fredrik/public_html/heller/".$imgdir;
	$files = scandir($path);
	$files = array_diff(scandir($path), array('.', '..'));
	foreach ($files as $f) {
		$mystring.="\"".$imgdir.$f."\",";
	}
	$mystring=rtrim($mystring, ',')."];";
	echo $mystring;
?> 

function preload(imageArray, index) {
        index = index || 0;
        if (imageArray && imageArray.length > index) {
            var img = new Image ();
            img.onload = function() {
                preload(imageArray, index + 1);
            }
            img.src = images[index];
	}
}
/* images is an array with image metadata */
preload(images);

function showimage(no) {
	document.images.slide.src = images[no];
}

function shownext() {
	imgno++;
	if (imgno>=images.length) {
		// alert("Reached end, wrapping around.");
		imgno=0;
	}
	showimage(imgno);
}

function showprevious() {
	imgno--;
	if (imgno<0) {
		// alert("Reached end, wrapping around.");
		imgno=images.length-1;
	}
	showimage(imgno);
}

</script>
</head>
<body>
<table width=500>
<tr><td>
<H1>Hellekombinasjoner</H1>
</td></tr>
<tr><td>
Veldig forenklet tilfelle:<BR>
<ul>
<li>Bare 60x60 og 40x60 heller (ikke 60x40 eller 40x40).</li>
<li>Symmetrikrav: Horisontalt og vertikalt speilplan.</li>
<li>To og bare to 40x60 heller per horisontal rad.</li>
</ul>
Dette gir 256 mulige kombinasjoner.
Scenarionummerering er basert p&aring; kj&oslash;ring uten begrensning i antall 40x60 heller per rad, som gir 6561 mulige kombinasjoner.
<BR>
<HR>
</td></tr>
<tr><td align="center">
	<input type="button" value="Previous" onclick="showprevious()" />
	<input type="button" value="Next" onclick="shownext()" />
<BR>
<HR>
</td></tr>
<tr><td>
<p><img src="images/test1.png" width="500" height="400" name="slide" /></p>
</td></tr>

</body>
