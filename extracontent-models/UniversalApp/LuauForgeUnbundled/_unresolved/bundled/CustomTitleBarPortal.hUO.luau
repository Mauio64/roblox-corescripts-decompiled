local module = require("@luauforge/bundled/hUP")
local module2 = require("@luauforge/bundled/hUQ")

local module3 = require("@luauforge/bundled/hUR")
local windowProtocolService = module3.WindowProtocolService
local coreGui = module3.CoreGui

local module4 = require("@luauforge/bundled/hUS")

local module5 = require("@luauforge/bundled/hVh")

local defineFastInt = game:DefineFastInt("CustomTitleBarDesiredHeight", 28)

local function CustomTitleBarPortal(p2)
	if not windowProtocolService:IsAvailable() then
		return nil
	end

	local value = Enum.KnownWindow.Main.Value
	local logicalCaptionButtonsBounds = windowProtocolService:GetLogicalCaptionButtonsBounds(value)

	local v5 = math.max(defineFastInt, logicalCaptionButtonsBounds.Height)

	if module5 then
		v5 = math.ceil(v5)
	end

	return module2.createPortal({
		CustomTitleBarScreenGui = module.createElement(
			"ScreenGui",
			{
				Enabled = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = p2.displayOrder,
				IgnoresTitleBarReservation = true
			},
			{
				CustomTitleBar = module.createElement(module4, {
					window = value,
					height = v5,
					title = p2.title
				})
			}
		)
	}, coreGui)
end

return CustomTitleBarPortal
