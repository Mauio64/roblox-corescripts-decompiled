local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local OnScreenKeyboardWindow = require(Modules.LuaApp.Components.OnScreenKeyboardWindow)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local withStyle = UIBlox.Core.Style.withStyle
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local v13 = Roact.PureComponent:extend(script.Name)

v13.defaultProps = {
	makeBodyFragment = function() -- line: 23
		return nil
	end
}

function v13.init(p1) -- line: 28
	function p1.closeModal() -- line: 29
		-- upvalues: p1 (copy)
		p1.props.closeOverlay()

		if p1.props.closeCallback then
			p1.props.closeCallback()
		end
	end
	function p1.getAdjustedTitleToScreenString(p2, p3, p4) -- line: 37
		-- upvalues: p1 (copy)
		if p2 == nil then
			return p2
		end

		local v29 = math.floor(0.85 * (p3 / (p4.Font.Body.RelativeSize * p4.Font.BaseSize * 0.6)))

		if v29 >= string.len(p2) then
			return p2
		end

		if p2:find(" ") == nil then
			return p2
		end

		p1.adjustedTitle = ""
		p1.remainingTitleToAnalyze = p2

		for i = 1, 2 do
			if not (v29 < string.len(p1.remainingTitleToAnalyze)) then
				p1.adjustedTitle = p1.adjustedTitle .. p1.remainingTitleToAnalyze

				return p1.adjustedTitle
			end

			local v31 = string.sub(p1.remainingTitleToAnalyze, 1, v29)
			local v32 = v31:reverse():find(" ")

			if v32 ~= nil then
				local v33 = string.len(v31) - v32

				p1.remainingTitleToAnalyze = string.sub(p1.remainingTitleToAnalyze, v33 + 2)
				p1.adjustedTitle = p1.adjustedTitle .. string.sub(v31, 0, v33)
			else
				p1.adjustedTitle = p1.adjustedTitle .. v31
				p1.remainingTitleToAnalyze = string.sub(p1.remainingTitleToAnalyze, v29 + 1)
			end

			if i ~= 2 then
				p1.adjustedTitle = p1.adjustedTitle .. "\n"
			end
		end

		return p1.adjustedTitle
	end
end
function v13.render(p5) -- line: 107
	-- upvalues: getPartialPageModalMiddleContentWidth (copy), withStyle (copy), Roact (copy), OnScreenKeyboardWindow (copy), PartialPageModal (copy)
	local screenSize = p5.props.screenSize
	local v18 = getPartialPageModalMiddleContentWidth(screenSize.X)
	local buttonConfig = p5.props.buttonConfig
	local makeBodyFragment = p5.props.makeBodyFragment
	local v21 = not p5.props.hideCloseButton
	local title = p5.props.title

	return withStyle(function(p6) -- line: 117
		-- upvalues: p5 (copy), title (copy), v18 (copy), Roact (copy), OnScreenKeyboardWindow (copy), PartialPageModal (copy), screenSize (copy), buttonConfig (copy), v21 (copy), makeBodyFragment (copy)
		local v35 = p5.getAdjustedTitleToScreenString(title, v18, p6)

		return Roact.createElement(OnScreenKeyboardWindow, {
			Contents = {
				Modal = Roact.createElement(PartialPageModal, {
					title = v35,
					screenSize = screenSize,
					buttonStackProps = buttonConfig,
					onCloseClicked = v21 and p5.closeModal
				}, {
					Middle = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0)
					}, {
						ContentPadding = Roact.createElement("UIPadding", {
							PaddingBottom = buttonConfig and UDim.new(0, 24),
							PaddingTop = UDim.new(0, 24)
						}),
						ListLayout = Roact.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 24),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						BodyFragment = makeBodyFragment(v18)
					})
				})
			}
		})
	end)
end

local v14 = RoactRodux.connect(function(p7, _) -- line: 149
	return {
		screenSize = p7.ScreenSize
	}
end, function(p9) -- line: 153
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeOverlay = function() -- line: 155
			-- upvalues: p9 (copy), CloseCentralOverlay (copy)
			return p9(CloseCentralOverlay())
		end
	}
end)(v13)

return (RoactServices.connect({
	analytics = RoactAnalytics
})(v14))
