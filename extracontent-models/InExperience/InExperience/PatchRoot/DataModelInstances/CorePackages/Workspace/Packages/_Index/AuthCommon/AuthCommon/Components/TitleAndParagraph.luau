local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local ArgCheck = require(parent.ArgCheck)
local FitChildren = require(AuthCommon.Components.FitChildren)
local FitTextLabel = require(AuthCommon.Components.FitTextLabel)
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor

local extended = Roact.PureComponent:extend("TitleAndParagraph")

local RegisterAuditContent = require(AuthCommon.Components.RegisterAuditContent)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagEnableAuditForSso = SharedFlags.GetFFlagEnableAuditForSso

extended.defaultProps = {
	layoutOrder = 0,
	textXAlignment = Enum.TextXAlignment.Left,
	paragraphTextKeys = {},
	paragraphTextArgs = {}
}

function extended:init()
	self.parametersCache = {}
end

function extended:getCachedParameters(p: string, items)
	if type(items) ~= "table" then
		return nil
	end

	local v = self.parametersCache[p]

	if v then
		return v
	end

	local result = {}

	for k, item in pairs(items) do
		if type(k) == "string" then
			result[k] = tostring(item)
		end
	end

	self.parametersCache[p] = result
	return result
end

local function fn(i) -- 2 equivalent calls inferred from this helper
	return "paragraphText" .. tostring(i)
end

local function fn2(i) -- 2 equivalent calls inferred from this helper
	return "paragraphTextTemplate" .. tostring(i)
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

	local v = { titleText = titleTextKey }

	for i, paragraphTextKey in ipairs(paragraphTextKeys) do
		v[fn(i)] = paragraphTextKey -- inferred equivalent call

		if not (GetFFlagEnableAuditForSso() and GetFFlagEnableAuditForSinglePageSignUp() and self.props.enableAuditContentCapture and type(paragraphTextKey) == "table") then
			continue
		end

		v[fn2(i)] = paragraphTextKey[1] -- inferred equivalent call
	end

	if
		not GetFFlagEnableAuditForSso()
		and GetFFlagEnableAuditForSinglePageSignUp()
		and self.props.enableAuditContentCapture
	then
		v.verificationLinkingTextTemplate = "Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName"
	end

	return withLocalization(v)(function(p)
		return withStyle(function(p2)
			local textSize = p2.Font.BaseSize * p2.Font.Title.RelativeSize
			local font = p2.Font.Title.Font

			local textSize2 = p2.Font.BaseSize * p2.Font.Body.RelativeSize
			local font2 = p2.Font.Body.Font
			local v2

			if formFactor2 == formFactor.COMPACT then
				textSize = p2.Font.BaseSize * p2.Font.Title.RelativeMinSize

				textSize2 = p2.Font.BaseSize * p2.Font.Body.RelativeMinSize
				v2 = 5
			else
				v2 = 12
			end

			local count = 0
			local children = {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v2)
				}),
				Title = p.titleText and Roact.createElement(FitTextLabel, {
					LayoutOrder = count,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = textXAlignment,
					TextYAlignment = Enum.TextYAlignment.Top,
					Text = p.titleText,
					TextSize = textSize,
					Font = font,
					TextColor3 = p2.Theme.SystemPrimaryDefault.Color,
					TextTransparency = p2.Theme.SystemPrimaryDefault.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					TextWrapped = true
				})
			}

			for i, paragraphTextKey in ipairs(paragraphTextKeys) do
				count += 1
				local v3 = fn(i) -- inferred equivalent call
				local v4 = p[v3]
				children[v3] = Roact.createElement(FitTextLabel, {
					LayoutOrder = count,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = textXAlignment,
					TextYAlignment = Enum.TextYAlignment.Top,
					Text = v4,
					TextSize = textSize2,
					Font = font2,
					TextColor3 = p2.Theme.TextDefault.Color,
					TextTransparency = p2.Theme.TextDefault.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					TextWrapped = true
				})

				if not (GetFFlagEnableAuditForSinglePageSignUp() and self.props.enableAuditContentCapture and RegisterAuditContent and v4) then
					continue
				end

				local v5 = "AuditContent_" .. v3
				local translationKey

				if type(paragraphTextKey) == "table" then
					translationKey = paragraphTextKey[1]
				else
					translationKey = paragraphTextKey
				end

				if type(paragraphTextKey) == "table" then
					if GetFFlagEnableAuditForSso() then
						v4 = p[fn2(i)] -- inferred equivalent call
					else
						v4 = p.verificationLinkingTextTemplate
					end
				end

				children[v5] = Roact.createElement(RegisterAuditContent, {
					translationKey = translationKey,
					translatedSourceString = v4,
					parameters = self:getCachedParameters(v5, paragraphTextKey)
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

return (RoactRodux.connect(function(p, _)
	return { formFactor = p.FormFactor }
end)(extended))
