local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local ageRecommendationDetails = require("@luauforge/bundled/dBl").AgeRecommendations.AgeRecommendationDetails

local extended = Roact.PureComponent:extend("ExperienceGuidelinesList")

extended.validateProps = t.strictInterface({
	ageRecommendations = ageRecommendationDetails.validateModel,
	localization = t.table,
	layoutOrder = t.optional(t.number)
})

function extended:init()
	function self.createDescriptorLabels(p3, list)
		local children = {}

		for i, item in ipairs(list) do
			children["Descriptor" .. i] = Roact.createElement(styledTextLabel, {
				layoutOrder = i + 1,
				fontStyle = p3.Font.Body,
				colorStyle = p3.Theme.TextDefault,
				size = UDim2.new(1, 0, 0, 0),
				fluidSizing = false,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				text = item.displayName
			})
		end

		return children
	end

	function self.createContentList(p3, p4)
		local descriptorLabels = {}

		descriptorLabels.Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 8)
		})

		local descriptorLabels2 = self.createDescriptorLabels(p3, p4)

		for k, descriptorLabel in pairs(descriptorLabels2) do
			descriptorLabels[k] = descriptorLabel
		end

		return descriptorLabels
	end

	self.createDescriptors = memoize(function(p3)
		local result = {}
		local descriptorUsages = p3.descriptorUsages

		if descriptorUsages == nil then
			return result
		end

		for i, descriptorUsage in ipairs(descriptorUsages) do
			local descriptor = descriptorUsage.descriptor

			if descriptor then
				result[i] = { displayName = descriptor.displayName }
			end
		end

		return result
	end)
end

function extended.render(data)
	local localization = data.props.localization
	local ageRecommendations = data.props.ageRecommendations
	local v5, v6

	if ageRecommendations then
		v5 = data.createDescriptors(ageRecommendations)
		local ageRecommendation = ageRecommendations.summary.ageRecommendation

		if ageRecommendation then
			v6 = ageRecommendation.displayName
		else
			v6 = localization:Format("Feature.GameDetails.Label.Unavailable")
		end
	else
		v6 = localization:Format("Feature.GameDetails.Label.Unavailable")
		v5 = {}
	end

	return withStyle(function(p2)
		local contentList = data.createContentList(p2, v5)
		local layoutOrder = data.props.layoutOrder

		return Roact.createElement("Frame", {
			LayoutOrder = layoutOrder,
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			MainLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 24)
			}),
			SummaryLabel = Roact.createElement(styledTextLabel, {
				layoutOrder = 1,
				fontStyle = p2.Font.Title,
				colorStyle = p2.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0, 0),
				fluidSizing = false,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				text = v6
			}),
			ListFrame = Roact.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1
			}, contentList)
		})
	end)
end

return (roactServices.connect({ localization = module })(extended))
