local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/fvl")
local module2 = require("@luauforge/deferred/hLi")
local module3 = require("@luauforge/bundled/dYT")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local withStyle = UIBlox.Core.Style.withStyle
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth

local extended = Roact.PureComponent:extend("ModalBase")

extended.defaultProps = {
	makeBodyFragment = function(): nil
		return nil
	end
}

function extended:init()
	function self.closeModal()
		self.props.closeOverlay()

		if self.props.closeCallback then
			self.props.closeCallback()
		end
	end

	function self.getAdjustedTitleToScreenString(remainingTitleToAnalyze, p2, p3)
		if remainingTitleToAnalyze == nil then
			return nil
		end

		local v5 = math.floor(0.85 * (p2 / (p3.Font.Body.RelativeSize * p3.Font.BaseSize * 0.6)))

		if string.len(remainingTitleToAnalyze) <= v5 or remainingTitleToAnalyze:find(" ") == nil then
			return remainingTitleToAnalyze
		end

		self.adjustedTitle = ""
		self.remainingTitleToAnalyze = remainingTitleToAnalyze

		for i = 1, 2 do
			if not (v5 < string.len(self.remainingTitleToAnalyze)) then
				self.adjustedTitle ..= self.remainingTitleToAnalyze
				break
			end

			local v6 = string.sub(self.remainingTitleToAnalyze, 1, v5)
			local v7 = v6:reverse():find(" ")

			if v7 == nil then
				self.adjustedTitle ..= v6

				self.remainingTitleToAnalyze = string.sub(self.remainingTitleToAnalyze, v5 + 1)
			else
				local v8 = string.len(v6) - v7

				self.remainingTitleToAnalyze = string.sub(self.remainingTitleToAnalyze, v8 + 2)

				self.adjustedTitle ..= string.sub(v6, 0, v8)
			end

			if i ~= 2 then
				self.adjustedTitle ..= "\n"
			end
		end

		return self.adjustedTitle
	end
end

function extended.render(data)
	local screenSize = data.props.screenSize
	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(screenSize.X)

	local buttonConfig = data.props.buttonConfig
	local makeBodyFragment = data.props.makeBodyFragment
	local v5 = not data.props.hideCloseButton
	local title = data.props.title

	return withStyle(function(p2)
		local adjustedTitleToScreenString = data.getAdjustedTitleToScreenString(
			title,
			partialPageModalMiddleContentWidth,
			p2
		)
		return Roact.createElement(module2, {
			Contents = {
				Modal = Roact.createElement(partialPageModal, {
					title = adjustedTitleToScreenString,
					screenSize = screenSize,
					buttonStackProps = buttonConfig,
					onCloseClicked = v5 and data.closeModal
				}, {
					Middle = Roact.createElement(
						"Frame",
						{
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 0)
						},
						{
							ContentPadding = Roact.createElement("UIPadding", {
								PaddingBottom = buttonConfig and UDim.new(0, 24),
								PaddingTop = UDim.new(0, 24)
							}),
							ListLayout = Roact.createElement("UIListLayout", {
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, 24),
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							BodyFragment = makeBodyFragment(partialPageModalMiddleContentWidth)
						}
					)
				})
			}
		})
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeOverlay = function()
			return callback(module())
		end
	}
end)(extended)

return (roactServices.connect({ analytics = module3 })(v5))
