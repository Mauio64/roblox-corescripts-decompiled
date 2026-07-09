local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useEffect = React.useEffect
local Constants = require(Modules.LuaApp.Constants)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local VRSettingsContent = require(Modules.LuaApp.Components.More.VRSettingsContent)

local function VRSettings(p1) -- line: 21
	-- upvalues: useStyle (copy), useEffect (copy), React (copy), TopBar (copy), MorePageScrollingFrame (copy), Constants (copy), VRSettingsContent (copy)
	local BackgroundDefault = useStyle().Theme.BackgroundDefault

	useEffect(function() -- line: 25
		return function() -- line: 26
			if game:GetEngineFeature("GlobalBasicSettingsSaveStateReflection") then
				task.spawn(function() -- line: 28
					UserSettings():SaveState()
				end)
			end
		end
	end)

	local paddings = p1.paddings

	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local contentMaxWidth = paddings.contentMaxWidth

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = BackgroundDefault.Color,
		BackgroundTransparency = BackgroundDefault.Transparency
	}, {
		TopBar = React.createElement(TopBar.Container, {
			leftItem = TopBar.BackButton
		}),
		PageContent = React.createElement(TopBar.PageContent, {}, {
			Scroller = React.createElement(MorePageScrollingFrame, {
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 1),
				maxWidth = contentMaxWidth
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, paddingHorizontal),
					PaddingRight = UDim.new(0, paddingHorizontal),
					PaddingTop = UDim.new(0, paddingVertical),
					PaddingBottom = UDim.new(0, paddingVertical)
				}),
				Content = React.createElement(VRSettingsContent)
			})
		})
	})
end

return require(Modules.LuaApp.Components.More.withMorePagePaddings)(VRSettings)
