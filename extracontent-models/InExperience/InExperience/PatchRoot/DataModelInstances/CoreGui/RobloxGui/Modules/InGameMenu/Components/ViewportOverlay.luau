local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local GlobalConfig = require(ParentParent.GlobalConfig)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local vector2 = Vector2.new(0, 0)
local v13 = t.strictInterface({
	currentPage = t.string,
	open = t.boolean,
	onActivated = t.callback,
	occupiedWidth = t.number,
	screenSize = t.Vector2
})

local function ViewportOverlay(p1) -- line: 28
	-- upvalues: GlobalConfig (copy), v13 (copy), vector2 (copy), Constants (copy), withStyle (copy), Roact (copy)
	if GlobalConfig.propValidation then
		assert(v13(p1))
	end

	if p1.screenSize == vector2 then
		return nil
	end

	local v16 = p1.currentPage == Constants.InitalPageKey

	return withStyle(function(p2) -- line: 39
		-- upvalues: Roact (copy), v16 (copy), p1 (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 0,
			BackgroundColor3 = p2.Theme.Overlay.Color,
			BackgroundTransparency = p2.Theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = not v16 and p1.open
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

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 60
	return {
		occupiedWidth = 464,
		currentPage = p3.menuPage,
		open = p3.isMenuOpen,
		screenSize = p3.screenSize
	}
end, function(p5) -- line: 69
	-- upvalues: CloseMenu (copy)
	return {
		onActivated = function() -- line: 71
			-- upvalues: p5 (copy), CloseMenu (copy)
			p5(CloseMenu)
		end
	}
end)(ViewportOverlay)
