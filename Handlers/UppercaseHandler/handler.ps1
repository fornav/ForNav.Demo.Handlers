#
# Sample handler that will convert a string to uppercase
#

# Get the input and output file names from the command line
$inputfile = $args[0]
$outputfile = $args[1]

# Read the input file as a JSON document
$package = Get-Content -Raw $inputfile | ConvertFrom-Json

# Create the result and save it to the output file
$result = @{}
$result["outputtext"] = $package.inputtext.ToUpper()
$result | ConvertTo-Json | Out-File $outputfile