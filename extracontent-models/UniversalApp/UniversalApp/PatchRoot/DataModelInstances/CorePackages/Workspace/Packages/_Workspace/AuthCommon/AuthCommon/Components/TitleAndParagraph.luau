local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local RoactRodux = require(AuthCommonParent.RoactRodux)
local withLocalization = require(AuthCommonParent.Localization).withLocalization
local withStyle = require(AuthCommonParent.UIBlox).Style.withStyle
local ArgCheck = require(AuthCommonParent.ArgCheck)
local FitChildren = require(AuthCommon.Components.FitChildren)
local FitTextLabel = require(AuthCommon.Components.FitTextLabel)
local FormFactor = require(AuthCommonParent.FormFactor).Enums.FormFactor
local v11 = Roact.PureComponent:extend("TitleAndParagraph")
local RegisterAuditContent = require(AuthCommon.Components.RegisterAuditContent)
local SharedFlags = require(AuthCommonParent.SharedFlags)
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagEnableAuditForSso = SharedFlags.GetFFlagEnableAuditForSso

v11.defaultProps = {
	layoutOrder = 0,
	textXAlignment = Enum.TextXAlignment.Left,
	paragraphTextKeys = {},
	paragraphTextArgs = {}
}

function v11.init(p1) -- line: 35
	p1.parametersCache = {}
end
function v11.getCachedParameters(t1: {[any]: any}, s1: string, p2) -- line: 40
	if type(p2) ~= "table" then
		return nil
	end

	local v20 = t1.parametersCache[s1]

	if v20 then
		return v20
	end

	local t2 = {}

	for k, v in pairs(p2) do
		if type(k) == "string" then
			t2[k] = tostring(v)
		end
	end

	t1.parametersCache[s1] = t2

	return t2
end
function v11.render(p3) -- line: 78
	-- upvalues: ArgCheck (copy), GetFFlagEnableAuditForSso (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), withLocalization (copy), withStyle (copy), FormFactor (copy), Roact (copy), FitTextLabel (copy), FitChildren (copy), RegisterAuditContent (copy)
	local formFactor = p3.props.formFactor
	local layoutOrder = p3.props.layoutOrder
	local titleTextKey = p3.props.titleTextKey
	local paragraphTextKeys = p3.props.paragraphTextKeys
	local width = p3.props.width
	local textXAlignment = p3.props.textXAlignment

	ArgCheck.isType(paragraphTextKeys, "table", "TitleAndParagraph expects paragraphTextKeys to be a table.")

	local uDim2 = UDim2.new(1, 0, 0, 0)

	if width then
		uDim2 = UDim2.new(0, width, 0, 0)
	end

	local t3 = {
		titleText = titleTextKey
	}

	for i, v in ipairs(paragraphTextKeys) do
		t3["paragraphText" .. tostring(i)] = v

		if GetFFlagEnableAuditForSso() and GetFFlagEnableAuditForSinglePageSignUp() and p3.props.enableAuditContentCapture and type(v) == "table" then
			t3["paragraphTextTemplate" .. tostring(i)] = v[1]
		end
	end

	if not GetFFlagEnableAuditForSso() and GetFFlagEnableAuditForSinglePageSignUp() and p3.props.enableAuditContentCapture then
		t3.verificationLinkingTextTemplate = "Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName"
	end

	return withLocalization(t3)(function(p4) -- line: 122
		-- upvalues: withStyle (copy), formFactor (copy), FormFactor (copy), Roact (copy), FitTextLabel (copy), textXAlignment (copy), FitChildren (copy), paragraphTextKeys (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), p3 (copy), RegisterAuditContent (copy), GetFFlagEnableAuditForSso (copy), layoutOrder (copy), uDim2 (ref)
		return withStyle(function(p5) -- line: 123
			-- upvalues: formFactor (copy), FormFactor (copy), Roact (copy), p4 (copy), FitTextLabel (copy), textXAlignment (copy), FitChildren (copy), paragraphTextKeys (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), p3 (copy), RegisterAuditContent (copy), GetFFlagEnableAuditForSso (copy), layoutOrder (copy), uDim2 (ref)
			local v41 = p5.Font.BaseSize * p5.Font.Title.RelativeSize
			local TitleFont = p5.Font.Title.Font
			local n1 = 12
			local v44 = p5.Font.BaseSize * p5.Font.Body.RelativeSize
			local BodyFont = p5.Font.Body.Font

			if formFactor == FormFactor.COMPACT then
				v41 = p5.Font.BaseSize * p5.Font.Title.RelativeMinSize
				n1 = 5
				v44 = p5.Font.BaseSize * p5.Font.Body.RelativeMinSize
			end

			local n2 = 0
			local t4 = {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, n1)
				}),
				Title = p4.titleText and Roact.createElement(FitTextLabel, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = n2,
					TextXAlignment = textXAlignment,
					TextYAlignment = Enum.TextYAlignment.Top,
					Text = p4.titleText,
					TextSize = v41,
					Font = TitleFont,
					TextColor3 = p5.Theme.SystemPrimaryDefault.Color,
					TextTransparency = p5.Theme.SystemPrimaryDefault.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				})
			}

			for i, v in ipairs(paragraphTextKeys) do
				n2 += 1

				local v50 = "paragraphText" .. tostring(i)
				local v51 = p4[v50]

				t4[v50] = Roact.createElement(FitTextLabel, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = n2,
					TextXAlignment = textXAlignment,
					TextYAlignment = Enum.TextYAlignment.Top,
					Text = v51,
					TextSize = v44,
					Font = BodyFont,
					TextColor3 = p5.Theme.TextDefault.Color,
					TextTransparency = p5.Theme.TextDefault.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				})

				if GetFFlagEnableAuditForSinglePageSignUp() and p3.props.enableAuditContentCapture and RegisterAuditContent and v51 then
					local v52 = "AuditContent_" .. v50
					local v53 = if type(v) ~= "table" then v else v[1]
					local v54 = if type(v) ~= "table" then v51 else if not GetFFlagEnableAuditForSso() then p4.verificationLinkingTextTemplate else p4["paragraphTextTemplate" .. tostring(i)]

					t4[v52] = Roact.createElement(RegisterAuditContent, {
						translationKey = v53,
						translatedSourceString = v54,
						parameters = p3:getCachedParameters(v52, v)
					})
				end
			end

			return Roact.createElement(FitChildren.FitFrame, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Size = uDim2,
				fitAxis = FitChildren.FitAxis.Height
			}, t4)
		end)
	end)
end

return (RoactRodux.connect(function(p6, _) -- line: 223
	return {
		formFactor = p6.FormFactor
	}
end)(v11))
