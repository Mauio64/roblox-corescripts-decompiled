local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useEffect = React.useEffect

local module = require("@luauforge/bundled/dzD")

local module2 = require("@luauforge/bundled/fvR")
local module3 = require("@luauforge/bundled/fGj")
local module4 = require("@luauforge/deferred/hSf")

local function VRSettings(p2)
	local backgroundDefault = useStyle().Theme.BackgroundDefault

	useEffect(function()
		return function()
			if game:GetEngineFeature("GlobalBasicSettingsSaveStateReflection") then
				task.spawn(function()
					UserSettings():SaveState()
				end)
			end
		end
	end)

	local paddings = p2.paddings
	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local contentMaxWidth = paddings.contentMaxWidth

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = backgroundDefault.Color,
			BackgroundTransparency = backgroundDefault.Transparency
		},
		{
			TopBar = React.createElement(module2.Container, {
				leftItem = module2.BackButton
			}),
			PageContent = React.createElement(module2.PageContent, {}, {
				Scroller = React.createElement(
					module3,
					{
						Position = UDim2.fromScale(0, 0),
						Size = UDim2.fromScale(1, 1),
						maxWidth = contentMaxWidth
					},
					{
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, module.MORE_PAGE_SECTION_PADDING)
						}),
						UIPadding = React.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, paddingHorizontal),
							PaddingRight = UDim.new(0, paddingHorizontal),
							PaddingTop = UDim.new(0, paddingVertical),
							PaddingBottom = UDim.new(0, paddingVertical)
						}),
						Content = React.createElement(module4)
					}
				)
			})
		}
	)
end

return require("@luauforge/deferred/fHR")(VRSettings)
