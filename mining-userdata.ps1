# AWS EC2 p3 mining userdata
Add-Type -assembly "system.io.compression.filesystem"
$dir = "c:\test\"
# Download the file to a specific location
if(!(Test-Path -Path $dir )){
mkdir $dir
}

$batFile = $dir + "electroneum.bat"
$clnt = new-object System.Net.WebClient
$url = "https://github.com/nocow4bob/ec2mining/raw/master/ccminer.zip"
$file = $dir + "ccminer.zip"
$clnt.DownloadFile($url,$file)


# Unzip the file to specified location
$shell_app=new-object -com shell.application 
$zip_file = $shell_app.namespace($file) 
$destination = $shell_app.namespace("$dir") 
$destination.Copyhere($zip_file.items())

# write .bat file for electroneum mining
$mineAddr = "etnjvZq437kVdDbNEvPqA5HMySrvCLKRxeCGb5V4xzg9VhinvoqwXfTRnnfAmW95UYRsw86dkpZM4a2rGnjs5CgB9v6dqDYPFV"
$pool = "pool.electroneum.space:3333"
$exe = $dir + "ccminer-x64.exe"
$args = "-a cryptonight -o stratum+tcp://$pool -u $mineAddr -p x"
$command = "ccminer-x64 -a cryptonight -o stratum+tcp://$pool -u $mineAddr -p x"
$command | Out-File -filepath $batFile

Start-Process -filepath $exe -ArgumentList $args
