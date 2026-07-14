local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local GlobalConfig = require(ParentParent.GlobalConfig)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local vector2 = Vector2.new(0, 0)
local v12 = t.strictInterface({
	currentPage = t.string,
	open = t.boolean,
	onActivated = t.callback,
	occupiedWidth = t.number,
	screenSize = t.Vector2
})

local function ViewportOverlay(p1) -- line: 27
	-- upvalues: GlobalConfig (copy), v12 (copy), vector2 (copy), Constants (copy), withFoundationOrUIBloxStyle (copy), Roact (copy)
	if GlobalConfig.propValidation then
		assert(v12(p1))
	end

	if p1.screenSize == vector2 then
		return nil
	end

	local v15 = p1.currentPage == Constants.InitalPageKey

	return withFoundationOrUIBloxStyle(function(p2) -- line: 38
		return {
			Theme = {
				Overlay = {
					Color = p2.Color.Common.Scrim.Color3,
					Transparency = p2.Color.Common.Scrim.Transparency
				}
			}
		}
	end, function(p3) -- line: 44
		-- upvalues: Roact (copy), v15 (copy), p1 (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 0,
			BackgroundColor3 = p3.Theme.Overlay.Color,
			BackgroundTransparency = p3.Theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = not v15 and p1.open
		}, {
			InputCapturer = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(1, -p1.occupiedWidth, 1, 0),
				Text = "",
				[Roact.Event.Activated] = p1.onActivated
			})
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p4, _) -- line: 65
	return {
		occupiedWidth = 464,
		currentPage = p4.menuPage,
		open = p4.isMenuOpen,
		screenSize = p4.screenSize
	}
end, function(p6) -- line: 74
	-- upvalues: CloseMenu (copy)
	return {
		onActivated = function() -- line: 76
			-- upvalues: p6 (copy), CloseMenu (copy)
			p6(CloseMenu)
		end
	}
end)(ViewportOverlay)
