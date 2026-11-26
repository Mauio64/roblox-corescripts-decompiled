local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactRodux")
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").withLocalization

local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox").Style.withStyle

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitChildren")
local FitTextLabel = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitTextLabel")
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/FormFactor").Enums.FormFactor

local extended = Roact.PureComponent:extend("TitleAndParagraph")

local RegisterAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/RegisterAuditContent")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags")
local getFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local getFFlagEnableAuditForSso = SharedFlags.GetFFlagEnableAuditForSso

extended.defaultProps = {
	layoutOrder = 0,
	textXAlignment = Enum.TextXAlignment.Left,
	paragraphTextKeys = {},
	paragraphTextArgs = {}
}

function extended:init()
	self.parametersCache = {}
end

function extended:getCachedParameters(p3, items)
	if type(items) ~= "table" then
		return nil
	end

	local v5 = self.parametersCache[p3]

	if v5 then
		return v5
	end

	local result = {}

	for k, item in pairs(items) do
		if type(k) == "string" then
			result[k] = tostring(item)
		end
	end

	self.parametersCache[p3] = result
	return result
end

function extended:render()
	local formFactor2 = self.props.formFactor

	local layoutOrder = self.props.layoutOrder
	local titleTextKey = self.props.titleTextKey
	local paragraphTextKeys = self.props.paragraphTextKeys

	local width = self.props.width
	local textXAlignment = self.props.textXAlignment

	ArgCheck.isType(paragraphTextKeys, "table", "TitleAndParagraph expects paragraphTextKeys to be a table.")

	local udim = UDim2.new(1, 0, 0, 0)

	if width then
		udim = UDim2.new(0, width, 0, 0)
	end

	local v5 = { titleText = titleTextKey }

	for i, paragraphTextKey in ipairs(paragraphTextKeys) do
		v5["paragraphText" .. tostring(i)] = paragraphTextKey

		if not (getFFlagEnableAuditForSso() and getFFlagEnableAuditForSinglePageSignUp() and self.props.enableAuditContentCapture and type(paragraphTextKey) == "table") then
			continue
		end

		v5["paragraphTextTemplate" .. tostring(i)] = paragraphTextKey[1]
	end

	if
		not getFFlagEnableAuditForSso()
		and getFFlagEnableAuditForSinglePageSignUp()
		and self.props.enableAuditContentCapture
	then
		v5.verificationLinkingTextTemplate = "Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName"
	end

	return withLocalization(v5)(function(p2)
		return withStyle(function(p3)
			local v6 = p3.Font.BaseSize * p3.Font.Title.RelativeSize
			local font = p3.Font.Title.Font

			local v7 = p3.Font.BaseSize * p3.Font.Body.RelativeSize
			local font2 = p3.Font.Body.Font
			local v8

			if formFactor2 == formFactor.COMPACT then
				v6 = p3.Font.BaseSize * p3.Font.Title.RelativeMinSize

				v7 = p3.Font.BaseSize * p3.Font.Body.RelativeMinSize
				v8 = 5
			else
				v8 = 12
			end

			local count = 0
			local children = {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v8)
				}),
				Title = p2.titleText and Roact.createElement(FitTextLabel, {
					LayoutOrder = count,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = textXAlignment,
					TextYAlignment = Enum.TextYAlignment.Top,
					Text = p2.titleText,
					TextSize = v6,
					Font = font,
					TextColor3 = p3.Theme.SystemPrimaryDefault.Color,
					TextTransparency = p3.Theme.SystemPrimaryDefault.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					TextWrapped = true
				})
			}

			for i, paragraphTextKey in ipairs(paragraphTextKeys) do
				count += 1
				local v9 = "paragraphText" .. tostring(i)

				local v10 = p2[v9]
				children[v9] = Roact.createElement(FitTextLabel, {
					LayoutOrder = count,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = textXAlignment,
					TextYAlignment = Enum.TextYAlignment.Top,
					Text = v10,
					TextSize = v7,
					Font = font2,
					TextColor3 = p3.Theme.TextDefault.Color,
					TextTransparency = p3.Theme.TextDefault.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					TextWrapped = true
				})

				if not (getFFlagEnableAuditForSinglePageSignUp() and self.props.enableAuditContentCapture and RegisterAuditContent and v10) then
					continue
				end

				local v11 = "AuditContent_" .. v9

				local v12 = if type(paragraphTextKey) == "table" then paragraphTextKey[1] else paragraphTextKey

				if type(paragraphTextKey) == "table" then
					if getFFlagEnableAuditForSso() then
						v10 = p2["paragraphTextTemplate" .. tostring(i)]
					else
						v10 = p2.verificationLinkingTextTemplate
					end
				end

				children[v11] = Roact.createElement(RegisterAuditContent, {
					translationKey = v12,
					translatedSourceString = v10,
					parameters = self:getCachedParameters(v11, paragraphTextKey)
				})
			end

			return Roact.createElement(FitChildren.FitFrame, {
				LayoutOrder = layoutOrder,
				Size = udim,
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, children)
		end)
	end)
end

return (RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(extended))
