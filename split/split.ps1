$json = Get-Content -Raw -Path tracks.json | ConvertFrom-Json
$tracks = $json.tracks
#$firstMediaFile = dir .\* -include ('*.mp4', '*.avi') -recurse
$largestFile = gci | sort Length -desc
$sourceFile = $largestFile[0]
$sourceFileExtension = dir .\* -include ('*.mp4', '*.avi') -recurse | select BaseName,Extension
$sourceFileExtension = $sourceFileExtension[0].Extension
#Write-Output ($tracks.Count)
for($i = 0; $i -lt $tracks.Count; $i++)
{
	$track = $tracks[$i]
	Write-Output ($track.name + '//' + $track.start)
	$durationString  = $null
	
	if ($i + 1 -lt $tracks.Count){
	
		$StartDate=[datetime]("01/01/2018 " + $track.start)
		$EndDate=[datetime]("01/01/2018 " + $tracks[$i+1].start)
		$duration = NEW-TIMESPAN -Start $StartDate -End $EndDate
		$durationString = "" + $duration.Hours.ToString("00") + ":" + $duration.Minutes.ToString("00") + ":" + $duration.Seconds.ToString("00") + "." + $duration.Milliseconds.ToString("00")
	}
	
	$out = $json.artist + " - " + ($i+1).ToString("00") + " - " + $track.name+$sourceFileExtension
	$metaArtist = "" + $json.artist
	$metaName = "" + $track.name
	$metaYear = "" + $json.year
	$metaTrack = "" + ($i+1)
	if ($durationString) {
		ffmpeg -y -ss $track.start -i $sourceFile.Name -metadata year=$metaYear -metadata artist=$metaArtist -metadata title=$metaName -metadata track=$metaTrack -c copy -t $durationString $out
	} else {
		ffmpeg -y -ss $track.start -i $sourceFile.Name -metadata year=$metaYear -metadata artist=$metaArtist -metadata title=$metaName -metadata track=$metaTrack -c copy $out
	}

}
