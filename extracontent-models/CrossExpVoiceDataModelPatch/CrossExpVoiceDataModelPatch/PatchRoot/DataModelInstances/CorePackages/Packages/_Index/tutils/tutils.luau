local Tutils = {
	checkListConsistency = require(script.checkListConsistency),
	deepEqual = require(script.deepEqual),
	deepCopy = require(script.deepCopy),
	equalKey = require(script.equalKey),
	fieldCount = require(script.fieldCount),
	listDifferences = require(script.listDifferences),
	print = 0,
	shallowEqual = 0,
	tableDifference = 0,
	toString = 0
}
local Print = require(script.print)
Tutils.print = Print(print)
Tutils.shallowEqual = require(script.shallowEqual)
Tutils.tableDifference = require(script.tableDifference)
Tutils.toString = require(script.toString)
return Tutils
