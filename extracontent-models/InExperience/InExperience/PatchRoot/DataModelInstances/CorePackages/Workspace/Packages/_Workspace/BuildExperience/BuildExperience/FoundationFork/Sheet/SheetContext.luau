local FoundationParent = game:GetService("CorePackages").Packages._Index.Foundation.Foundation.Parent
local React = require(FoundationParent.React)

require(script.Parent.SheetType)

return React.createContext({
	sheetHeightAvailable = nil,
	actionsHeight = nil,
	hasActionsDivider = nil,
	sheetContentHeight = nil,
	safeAreaPadding = nil,
	bottomPadding = nil,
	innerScrollingEnabled = nil,
	innerScrollY = nil,
	hasHeader = nil,
	hasFullBleed = false,
	fullBleedHeight = nil,
	hasRadius = true,
	closeSheet = nil,
	sheetType = nil,
	innerSurface = nil,
	testId = nil,
	closeAffordanceRef = nil,
	contentStartRef = nil,
	setSheetHeightAvailable = function(_: number) -- line: 11
		error("No SheetContext available")
	end,
	setActionsHeight = function(_: number) -- line: 15
		error("No SheetContext available")
	end,
	setHasActionsDivider = function(_: boolean) -- line: 19
		error("No SheetContext available")
	end,
	setSheetContentHeight = function(_: number) -- line: 23
		error("No SheetContext available")
	end,
	setInnerScrollY = function(_: number) -- line: 30
		error("No SheetContext available")
	end,
	setHasHeader = function(_: boolean) -- line: 34
		error("No SheetContext available")
	end,
	setFullBleedHeight = function(_: number) -- line: 39
		error("No SheetContext available")
	end,
	setContentStartRef = function(_) -- line: 49
	end
})
