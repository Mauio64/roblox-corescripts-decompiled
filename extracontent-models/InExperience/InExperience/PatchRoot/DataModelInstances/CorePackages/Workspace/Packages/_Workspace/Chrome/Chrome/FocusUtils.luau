local FocusOnChrome = require(script.FocusOnChrome)
local FocusOffChrome = require(script.FocusOffChrome)
local FocusOnChromeSignal = require(script.FocusOnChromeSignal)
local FocusOffChromeSignal = require(script.FocusOffChromeSignal)
local MenuIconSelectedSignal = require(script.MenuIconSelectedSignal)

return {
	FocusOnChrome = FocusOnChrome,
	FocusOffChrome = FocusOffChrome,
	FocusOnChromeSignal = FocusOnChromeSignal,
	FocusOffChromeSignal = FocusOffChromeSignal,
	MenuIconSelectedSignal = MenuIconSelectedSignal
}
