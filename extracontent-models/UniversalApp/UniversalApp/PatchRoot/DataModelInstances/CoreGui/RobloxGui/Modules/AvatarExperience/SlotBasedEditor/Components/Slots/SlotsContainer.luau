local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSlotProps = require(script.Parent.useSlotProps)
local Slots = require(script.Parent.Slots)
local Cryo = require(CorePackages.Packages.Cryo)
local FFlagAXSlotsDisableScrollAwayOnLandscape = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDisableScrollAwayOnLandscape

local function SlotsContainer(p1) -- line: 13
	-- upvalues: useSlotProps (copy), React (copy), Slots (copy), FFlagAXSlotsDisableScrollAwayOnLandscape (copy), Cryo (copy)
	local v9 = useSlotProps(p1)

	return React.createElement(Slots, if not FFlagAXSlotsDisableScrollAwayOnLandscape then Cryo.Dictionary.join(v9, p1) else v9)
end

return SlotsContainer
