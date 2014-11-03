properties {
    $BaseDirectory = Resolve-Path ..     
    $Nuget = "$BaseDirectory\Tools\NuGet.exe"
	$SlnFile = "$BaseDirectory\Source\Chill.sln"
	$pluginSource = "$BaseDirectory\Source\Plugins"
	$7zip = "$BaseDirectory\Tools\7z.exe"
	$PackageDirectory = "$BaseDirectory\Package"
	$ApiKey = ""
    $AssemblyVer = "1.2.3.4"
	$InformationalVersion = "1.2.3-unstable.34+34.Branch.develop.Sha.19b2cd7f494c092f87a522944f3ad52310de79e0"
	$NuGetVersion = "1.2.3-unstable0012"
    $MsBuildLoggerPath = ""
	$Branch = ""
	$MsTestPath = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\MSTest.exe"
	$RunTests = $false
}

task default -depends Clean, ApplyAssemblyVersioning, ApplyPackageVersioning, Compile, RunTests, BuildZip, BuildPackage, PublishToMyget

task Clean {	
    
		Get-ChildItem $PackageDirectory *.nupkg | ForEach { Remove-Item $_.FullName }
		Get-ChildItem $PackageDirectory *.zip | ForEach { Remove-Item $_.FullName }
}

task ApplyAssemblyVersioning {
 	


}

task ApplyPackageVersioning {

}

task Compile {
   
	    exec { msbuild /v:m /p:Platform="Any CPU" $SlnFile /p:Configuration=Release /t:Rebuild}
   
}

task RunTests -precondition { return $RunTests -eq $true } {
	
}

task BuildZip {

}

task BuildPackage {
  & $Nuget pack "$PackageDirectory\Chill\.nuspec" -o "$PackageDirectory\Chill" 
  New-Item -ItemType Directory -Force -Path "$PackageDirectory\Chill.Autofac"
  & $Nuget pack "$pluginSource\Chill.Autofac\.nuspec" -o "$PackageDirectory\Chill.Autofac" 
  
  New-Item -ItemType Directory -Force -Path "$PackageDirectory\Chill.AutofacNSubstitute"
  & $Nuget pack "$pluginSource\Chill.AutofacNSubstitute\.nuspec" -o "$PackageDirectory\Chill.AutofacNSubstitute" 

  New-Item -ItemType Directory -Force -Path "$PackageDirectory\Chill.AutofacFakeItEasy"
  & $Nuget pack "$pluginSource\Chill.AutofacFakeItEasy\.nuspec" -o "$PackageDirectory\Chill.AutofacFakeItEasy" 

}

task PublishToMyget -precondition { return ($Branch -eq "master" -or $Branch -eq "<default>" -or $Branch -eq "develop") -and ($ApiKey -ne "") } {
}


