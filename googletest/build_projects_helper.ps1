# This script helps creating project files for benchmark.  The argument is the path of googletest/googletest/.
# It produces four pairs of *.vcxproj, *.vcxproj.filters files for the four projects.

$dir = resolve-path $args[0]

$filtersheaders = "  <ItemGroup>`r`n"
$vcxprojheaders = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\include\gtest\*" -Include *.h | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*include\\", "..\include\"
  $filtersheaders +=
      "    <ClInclude Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Header Files</Filter>`r`n" +
      "    </ClInclude>`r`n"
  $vcxprojheaders +=
      "    <ClInclude Include=`"$msvcrelativepath`" />`r`n"
}
Get-ChildItem "$dir\include\gtest\*\*" -Recurse -Include *.h | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*include\\", "..\include\"
  $filtersheaders +=
      "    <ClInclude Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Internal Files</Filter>`r`n" +
      "    </ClInclude>`r`n"
  $vcxprojheaders +=
      "    <ClInclude Include=`"$msvcrelativepath`" />`r`n"
}
$filtersheaders += "  </ItemGroup>`r`n"
$vcxprojheaders += "  </ItemGroup>`r`n"

$filterssources = "  <ItemGroup>`r`n"
$vcxprojsources = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\src\*" -Include *.h,*.cc -Exclude gtest_main.cc | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*src\\", "..\src\"
  $filterssources +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojsources +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filterssources += "  </ItemGroup>`r`n"
$vcxprojsources += "  </ItemGroup>`r`n"

$filtersmsources = "  <ItemGroup>`r`n"
$vcxprojmsources = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\src\*" -Include gtest_main.cc | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*src\\", "..\src\"
  $filtersmsources +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojmsources +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filtersmsources += "  </ItemGroup>`r`n"
$vcxprojmsources += "  </ItemGroup>`r`n"

$filterstests = "  <ItemGroup>`r`n"
$vcxprojtests = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\test\*" -Include *_test.h | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*test\\", "..\test\"
  $filterstests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Header Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojtests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
Get-ChildItem "$dir\test\*" -Include *_test.cc -Exclude *prod*.h,*prod*.cc | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*test\\", "..\test\"
  $filterstests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojtests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filterstests += "  </ItemGroup>`r`n"
$vcxprojtests += "  </ItemGroup>`r`n"

$filtersptests = "  <ItemGroup>`r`n"
$vcxprojptests = "  <ItemGroup>`r`n"
Get-ChildItem "$dir\test\*" -Include *prod*.h | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*test\\", "..\test\"
  $filtersptests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Header Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojptests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
Get-ChildItem "$dir\test\*" -Include *prod*.cc | `
Foreach-Object {
  $msvcrelativepath = $_.FullName -replace ".*test\\", "..\test\"
  $filtersptests +=
      "    <ClCompile Include=`"$msvcrelativepath`">`r`n" +
      "       <Filter>Source Files</Filter>`r`n" +
      "    </ClCompile>`r`n"
  $vcxprojptests +=
      "    <ClCompile Include=`"$msvcrelativepath`" />`r`n"
}
$filtersptests += "  </ItemGroup>`r`n"
$vcxprojptests += "  </ItemGroup>`r`n"

$dirfilterspath = [string]::format("{0}\gtest_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $dirfilterspath,
    $filtersheaders + $filterssources,
    [system.text.encoding]::utf8)

$mainfilterspath = [string]::format("{0}\gtest_main_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $mainfilterspath,
    $filtersmsources,
    [system.text.encoding]::utf8)

$ptestsfilterspath = [string]::format("{0}\gtest_prod_test_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $ptestsfilterspath,
    $filtersptests,
    [system.text.encoding]::utf8)

$otestsfilterspath = [string]::format("{0}\gtest_unittest_vcxproj_filters.txt", $dir)
[system.io.file]::writealltext(
    $otestsfilterspath,
    $filterstests,
    [system.text.encoding]::utf8)

$dirvcxprojpath = [string]::format("{0}\gtest_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $dirvcxprojpath,
    $vcxprojheaders + $vcxprojsources,
    [system.text.encoding]::utf8)

$mainvcxprojpath = [string]::format("{0}\gtest_main_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $mainvcxprojpath,
    $vcxprojmsources,
    [system.text.encoding]::utf8)

$ptestsvcxprojpath = [string]::format("{0}\gtest_prod_test_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $ptestsvcxprojpath,
    $vcxprojptests,
    [system.text.encoding]::utf8)

$testsvcxprojpath = [string]::format("{0}\gtest_unittest_vcxproj.txt", $dir)
[system.io.file]::writealltext(
    $testsvcxprojpath,
    $vcxprojtests,
    [system.text.encoding]::utf8)
