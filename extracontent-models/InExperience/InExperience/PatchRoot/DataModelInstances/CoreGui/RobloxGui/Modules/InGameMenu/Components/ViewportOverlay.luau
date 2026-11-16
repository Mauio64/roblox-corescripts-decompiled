local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent

local Constants = require(parent.Resources.Constants)

local GlobalConfig = require(parent.GlobalConfig)
local CloseMenu = require(parent.Thunks.CloseMenu)

local vector2 = Vector2.new(0, 0)

local strictInterface = t.strictInterface({
	currentPage = t.string,
	open = t.boolean,
	onActivated = t.callback,
	occupiedWidth = t.number,
	screenSize = t.Vector2
})

local function ViewportOverlay(data)
	if GlobalConfig.propValidation then
		assert(strictInterface(data))
	end

	if data.screenSize == vector2 then
		return nil
	end

	local v = data.currentPage == Constants.InitalPageKey

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				Overlay = {
					Color = p.Color.Common.Scrim.Color3,
					Transparency = p.Color.Common.Scrim.Transparency
				}
			}
		}
	end, function(p)
		return Roact.createElement("Frame", {
			BackgroundColor3 = p.Theme.Overlay.Color,
			BackgroundTransparency = p.Theme.Overlay.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = not v and data.open,
			ZIndex = 0
		}, {
			InputCapturer = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(1, -data.occupiedWidth, 1, 0),
				Text = "",
				[Roact.Event.Activated] = data.onActivated
			})
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		currentPage = data.menuPage,
		open = data.isMenuOpen,
		occupiedWidth = 464,
		screenSize = data.screenSize
	}
end, function(callback)
	return {
		onActivated = function()
			callback(CloseMenu)
		end
	}
end)(ViewportOverlay)
