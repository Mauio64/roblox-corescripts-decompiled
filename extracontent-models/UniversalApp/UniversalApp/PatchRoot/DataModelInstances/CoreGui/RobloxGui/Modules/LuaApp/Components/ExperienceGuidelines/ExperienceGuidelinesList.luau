local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local AgeRecommendationDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.AgeRecommendationDetails
local v12 = Roact.PureComponent:extend("ExperienceGuidelinesList")

v12.validateProps = t.strictInterface({
	ageRecommendations = AgeRecommendationDetails.validateModel,
	localization = t.table,
	layoutOrder = t.optional(t.number)
})

function v12.init(p1) -- line: 25
	-- upvalues: Roact (copy), StyledTextLabel (copy), memoize (copy)
	function p1.createDescriptorLabels(p2, p3) -- line: 26
		-- upvalues: Roact (copy), StyledTextLabel (copy)
		local t1 = {}

		for i, v in ipairs(p3) do
			t1["Descriptor" .. i] = Roact.createElement(StyledTextLabel, {
				fluidSizing = false,
				layoutOrder = i + 1,
				fontStyle = p2.Font.Body,
				colorStyle = p2.Theme.TextDefault,
				size = UDim2.new(1, 0, 0, 0),
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				text = v.displayName
			})
		end

		return t1
	end
	function p1.createContentList(p4, p5) -- line: 45
		-- upvalues: Roact (copy), p1 (copy)
		local t2 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 8)
			})
		}
		local v28 = p1.createDescriptorLabels(p4, p5)

		for k, v in pairs(v28) do
			t2[k] = v
		end

		return t2
	end

	p1.createDescriptors = memoize(function(p6) -- line: 63
		local t3 = {}
		local descriptorUsages = p6.descriptorUsages

		if descriptorUsages ~= nil then
			for i, v in ipairs(descriptorUsages) do
				local descriptor = v.descriptor

				if descriptor then
					t3[i] = {
						displayName = descriptor.displayName
					}
				end
			end
		end

		return t3
	end)
end
function v12.render(p7) -- line: 82
	-- upvalues: withStyle (copy), Roact (copy), StyledTextLabel (copy)
	local localization = p7.props.localization
	local ageRecommendations = p7.props.ageRecommendations
	local u17, u19

	if ageRecommendations then
		u17 = p7.createDescriptors(ageRecommendations)

		local ageRecommendation = ageRecommendations.summary.ageRecommendation

		u19 = if not ageRecommendation then localization:Format("Feature.GameDetails.Label.Unavailable") else ageRecommendation.displayName
	else
		u17 = {}
		u19 = localization:Format("Feature.GameDetails.Label.Unavailable")
	end

	return withStyle(function(p8) -- line: 99
		-- upvalues: p7 (copy), u17 (ref), Roact (copy), StyledTextLabel (copy), u19 (ref)
		local v38 = p7.createContentList(p8, u17)
		local layoutOrder = p7.props.layoutOrder

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			BackgroundColor3 = p8.Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			MainLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 24)
			}),
			SummaryLabel = Roact.createElement(StyledTextLabel, {
				layoutOrder = 1,
				fluidSizing = false,
				fontStyle = p8.Font.Title,
				colorStyle = p8.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0, 0),
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				text = u19
			}),
			ListFrame = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BorderSizePixel = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromOffset(0, 0)
			}, v38)
		})
	end)
end

return (RoactServices.connect({
	localization = RoactLocalization
})(v12))
