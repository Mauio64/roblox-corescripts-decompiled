local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local RoactRodux = require(AuthCommonParent.RoactRodux)
local RoactServices = require(AuthCommonParent.RoactServices).RoactServices
local RoactNetworking = require(AuthCommonParent.RoactServiceTags).RoactNetworking
local t = require(AuthCommonParent.t)
local tutils = require(AuthCommonParent.tutils)
local ArgCheck = require(AuthCommonParent.ArgCheck)
local UIBlox = require(AuthCommonParent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(AuthCommonParent.Localization).withLocalization
local FitChildren = require(AuthCommon.Components.FitChildren)
local FitTextLabel = require(AuthCommon.Components.FitTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(AuthCommonParent.RobloxAppAssets).GetImageData
local Logger = require(AuthCommon.Components.Logger)
local IssueCondition = require(AuthCommon.Enums.IssueCondition)
local InputValidity = require(AuthCommon.Enums.InputValidity)
local v20 = Roact.createBinding(0)
local v21 = t.interface({
	validateFunction = t.callback,
	getIssueMessageList = t.callback,
	getDefaultIssues = t.callback
})
local v22 = Roact.PureComponent:extend("IssueTracker")
local SharedFlags = require(AuthCommonParent.SharedFlags)
local FFlagSignUpTrackFailedRequest = SharedFlags.FFlagSignUpTrackFailedRequest
local FFlagLuaEnableIssueTrackerSorting = SharedFlags.FFlagLuaEnableIssueTrackerSorting

function v22.init(p1) -- line: 51
	-- upvalues: v21 (copy), IssueCondition (copy), InputValidity (copy), Roact (copy), FFlagSignUpTrackFailedRequest (copy), Logger (copy), tutils (copy)
	local validator = p1.props.validator

	assert(v21(validator))

	local v29 = validator.getIssueMessageList()
	local v30 = validator.getDefaultIssues()
	local t1 = {}

	for k in pairs(v29) do
		t1[k] = v30[k] ~= IssueCondition.Hidden and true
	end

	p1.state = {
		listOfIssuesOnDisplay = t1,
		issueMessageList = v29,
		issueCondition = v30,
		inputValidity = InputValidity.Unvalidated
	}
	p1.isMounted = false
	p1.containerRef = Roact.createRef()

	function p1.validateText() -- line: 78
		-- upvalues: p1 (copy), v21 (copy), validator (copy), InputValidity (copy), FFlagSignUpTrackFailedRequest (copy), Logger (copy)
		local networking = p1.props.networking
		local textToValidate = p1.props.textToValidate
		local validate = p1.props.validate
		local validatorAdditionalProps = p1.props.validatorAdditionalProps
		local issueCondition = p1.state.issueCondition

		assert(v21(validator))
		validate(networking, validator.validateFunction, textToValidate, issueCondition, validatorAdditionalProps):andThen(function(p2) -- line: 91
			-- upvalues: p1 (copy), InputValidity (copy), FFlagSignUpTrackFailedRequest (copy)
			spawn(function() -- line: 92
				-- upvalues: p1 (copy), InputValidity (copy), p2 (copy), FFlagSignUpTrackFailedRequest (copy)
				local onTextValidated = p1.props.onTextValidated
				local textToValidate2 = p1.props.textToValidate
				local Invalid = InputValidity.Invalid

				if p1.isMounted and textToValidate2 == p2.Input then
					if textToValidate2 == "" then
						Invalid = InputValidity.Unvalidated
					elseif p2.InputValid then
						Invalid = InputValidity.Valid
					end

					if onTextValidated then
						if FFlagSignUpTrackFailedRequest then
							onTextValidated(p2.Input, Invalid, p2.hasRequestFailed)
						else
							onTextValidated(p2.Input, Invalid)
						end
					end

					p1:setState({
						issueCondition = p2.IssueCondition,
						inputValidity = Invalid
					})

					if p1.props.updateIssueCondition then
						p1.props.updateIssueCondition(p2.IssueCondition)
					end
				end
			end)
		end, function(p3) -- line: 124
			-- upvalues: Logger (copy), p1 (copy), InputValidity (copy)
			Logger:warning(string.format("Input issueTracker error: %s", (tostring(p3))))
			p1:setState({
				inputValidity = InputValidity.Unvalidated
			})
		end)
	end
	function p1.updateListOfIssuesOnDisplay() -- line: 134
		-- upvalues: p1 (copy), IssueCondition (copy), tutils (copy)
		local height = p1.props.height
		local issueMessageList = p1.state.issueMessageList
		local issueCondition = p1.state.issueCondition
		local n1 = 0
		local t2 = {}
		local t3 = {}
		local t4 = {}
		local t5 = {}
		local v60 = p1.containerRef.current and p1.containerRef.current:GetChildren() or {}

		for _, v in pairs(v60) do
			if v:IsA("GuiObject") then
				t5[v.Name] = v.AbsoluteSize.Y
			end
		end

		for k in pairs(issueMessageList) do
			t2[k] = false

			local v64 = issueCondition[k] == IssueCondition.Problematic

			if issueCondition[k] ~= IssueCondition.Hidden then
				local v65 = t5[k] or 0

				table.insert(t3, k)
				n1 += v65

				if not v64 then
					table.insert(t4, #t3)
				end
			end
		end

		local v66 = n1 + (#t3 - 1) * 5

		if height then
			for i = #t4, 1, -1 do
				if not (height < v66) then
					break
				end

				local v68 = t4[i]

				v66 = v66 - (t5[t3[v68]] or 0) - 5
				table.remove(t3, v68)
			end

			for i = #t3, 1, -1 do
				if not (height < v66) then
					break
				end

				v66 = v66 - (t5[t3[i]] or 0) - 5
				table.remove(t3, i)
			end
		end

		for _, v in pairs(t3) do
			t2[v] = true
		end

		spawn(function() -- line: 210
			-- upvalues: p1 (copy), tutils (copy), t2 (copy)
			if p1.isMounted and not tutils.shallowEqual(t2, p1.state.listOfIssuesOnDisplay) then
				p1:setState({
					listOfIssuesOnDisplay = t2
				})
			end
		end)
	end
end
function v22.didMount(p4) -- line: 222
	p4.isMounted = true
	p4.updateListOfIssuesOnDisplay()
end
function v22.willUnmount(p5) -- line: 227
	p5.isMounted = false
end
function v22.didUpdate(p6, p7, _) -- line: 231
	-- upvalues: ArgCheck (copy), tutils (copy), FFlagSignUpTrackFailedRequest (copy)
	local validator = p6.props.validator
	local validatorAdditionalProps = p6.props.validatorAdditionalProps
	local textToValidate = p6.props.textToValidate

	if validator ~= p7.validator then
		ArgCheck.assert(validator == p7.validator, "IssueTracker expects the validator to never change")
	end

	if textToValidate ~= p7.textToValidate or not tutils.shallowEqual(validatorAdditionalProps, p7.validatorAdditionalProps) then
		spawn(function() -- line: 244
			-- upvalues: FFlagSignUpTrackFailedRequest (copy), p6 (copy), textToValidate (copy)
			if FFlagSignUpTrackFailedRequest then
				task.wait(not p6.props.debounceTime and 0.3 or p6.props.debounceTime)
			else
				wait(0.3)
			end

			if p6.props.textToValidate == textToValidate then
				p6.validateText()
			end
		end)
	end

	p6.updateListOfIssuesOnDisplay()
end
function v22.render(p9) -- line: 260
	-- upvalues: withStyle (copy), v20 (copy), Roact (copy), FFlagLuaEnableIssueTrackerSorting (copy), IssueCondition (copy), withLocalization (copy), InputValidity (copy), FitChildren (copy), ImageSetLabel (copy), GetImageData (copy), FitTextLabel (copy)
	local height = p9.props.height
	local issueMessageList = p9.state.issueMessageList
	local issueCondition = p9.state.issueCondition
	local listOfIssuesOnDisplay = p9.state.listOfIssuesOnDisplay

	return withStyle(function(p10) -- line: 268
		-- upvalues: p9 (copy), v20 (copy), Roact (copy), issueMessageList (copy), FFlagLuaEnableIssueTrackerSorting (copy), issueCondition (copy), IssueCondition (copy), withLocalization (copy), InputValidity (copy), FitChildren (copy), listOfIssuesOnDisplay (copy), ImageSetLabel (copy), GetImageData (copy), FitTextLabel (copy), height (copy)
		local CaptionBodyFont = p10.Font.CaptionBody.Font
		local v74 = p10.Font.BaseSize * p10.Font.CaptionBody.RelativeSize
		local contentTransparency = p9.props.contentTransparency
		local v76 = p9.props.checkmarkTransparency or v20

		if not contentTransparency then
			local TextDefaultTransparency = p10.Theme.TextDefault.Transparency

			if TextDefaultTransparency ~= p9.textDefaultTransparency then
				p9.textDefaultTransparency = TextDefaultTransparency
				p9.textDefaultTransparencyBinding = Roact.createBinding(TextDefaultTransparency)
			end

			contentTransparency = p9.textDefaultTransparencyBinding
		end

		local v78 = Roact.joinBindings({
			content = contentTransparency,
			checkmark = v76
		})
		local t6 = {}

		for k in pairs(issueMessageList) do
			table.insert(t6, k)
		end

		if FFlagLuaEnableIssueTrackerSorting and p9.props.sortProblematicIssues then
			table.sort(t6, function(p11, p12) -- line: 294
				-- upvalues: issueCondition (copy), IssueCondition (copy)
				if issueCondition[p11] == IssueCondition.Problematic and issueCondition[p12] ~= IssueCondition.Problematic then
					return true
				end

				return false
			end)
		end

		if FFlagLuaEnableIssueTrackerSorting then
			return withLocalization(issueMessageList)(function(p13) -- line: 307
				-- upvalues: Roact (copy), p9 (copy), t6 (copy), issueCondition (copy), IssueCondition (copy), InputValidity (copy), FitChildren (copy), listOfIssuesOnDisplay (copy), ImageSetLabel (copy), GetImageData (copy), p10 (copy), v78 (copy), FitTextLabel (copy), CaptionBodyFont (copy), v74 (copy), contentTransparency (ref), height (copy), v76 (copy)
				local t7 = { Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					[Roact.Change.AbsoluteContentSize] = p9.updateListOfIssuesOnDisplay
				}) }

				for i, v in ipairs(t6) do
					local v94 = issueCondition[v] == IssueCondition.Problematic
					local v95 = v94 and p9.state.inputValidity ~= InputValidity.Unvalidated

					t7[v] = Roact.createElement(FitChildren.FitFrame, {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						LayoutOrder = i,
						Visible = listOfIssuesOnDisplay[v]
					}, {
						List = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, 7),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						CheckHolder = Roact.createElement("Frame", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 12, 0, 12)
						}, {
							CheckMark = Roact.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								Image = if not v94 then GetImageData("LuaApp/icons/progress_small") or "LuaApp/icons/progress_small" else GetImageData("LuaApp/icons/navigation/close") or "LuaApp/icons/navigation/close",
								ImageColor3 = v95 and p10.Theme.Alert.Color or p10.Theme.TextDefault.Color,
								ImageTransparency = v78:map(function(p14) -- line: 344
									return (p14.content - 1) * (1 - p14.checkmark) + 1
								end),
								Size = UDim2.new(1, 0, 1, 0),
								Position = UDim2.new(0.5, 0, 0.65, 0),
								AnchorPoint = Vector2.new(0.5, 0.5)
							})
						}),
						IssueLabel = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							TextWrapped = true,
							Size = UDim2.new(1, 0, 0, 0),
							fitAxis = FitChildren.FitAxis.Height,
							Text = p13[v],
							Font = CaptionBodyFont,
							TextSize = v74,
							TextColor3 = v95 and p10.Theme.Alert.Color or p10.Theme.TextDefault.Color,
							TextTransparency = contentTransparency,
							TextXAlignment = Enum.TextXAlignment.Left
						})
					})
				end

				if height then
					return Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, height),
						BackgroundTransparency = 1,
						[Roact.Ref] = p9.containerRef,
						Position = v76:map(function(p15) -- line: 374
							return UDim2.new(0, 19 * -p15, 0, 0)
						end)
					}, t7)
				end

				return Roact.createElement(FitChildren.FitFrame, {
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					[Roact.Ref] = p9.containerRef,
					Position = v76:map(function(p16) -- line: 384
						return UDim2.new(0, 19 * -p16, 0, 0)
					end)
				}, t7)
			end)
		end

		return withLocalization(issueMessageList)(function(p17) -- line: 392
			-- upvalues: Roact (copy), p9 (copy), issueMessageList (copy), issueCondition (copy), IssueCondition (copy), InputValidity (copy), FitChildren (copy), listOfIssuesOnDisplay (copy), ImageSetLabel (copy), GetImageData (copy), p10 (copy), v78 (copy), FitTextLabel (copy), CaptionBodyFont (copy), v74 (copy), contentTransparency (ref), height (copy), v76 (copy)
			local t8 = { Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = p9.updateListOfIssuesOnDisplay
			}) }

			for k, v in pairs(issueMessageList) do
				local v100 = issueCondition[k] == IssueCondition.Problematic
				local v101 = v100 and p9.state.inputValidity ~= InputValidity.Unvalidated

				t8[k] = Roact.createElement(FitChildren.FitFrame, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					LayoutOrder = string.byte(v, #v),
					Visible = listOfIssuesOnDisplay[k]
				}, {
					List = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 7),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					CheckHolder = Roact.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 12, 0, 12)
					}, {
						CheckMark = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							Image = if not v100 then GetImageData("LuaApp/icons/progress_small") or "LuaApp/icons/progress_small" else GetImageData("LuaApp/icons/navigation/close") or "LuaApp/icons/navigation/close",
							ImageColor3 = v101 and p10.Theme.Alert.Color or p10.Theme.TextDefault.Color,
							ImageTransparency = v78:map(function(p18) -- line: 429
								return (p18.content - 1) * (1 - p18.checkmark) + 1
							end),
							Size = UDim2.new(1, 0, 1, 0),
							Position = UDim2.new(0.5, 0, 0.65, 0),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					}),
					IssueLabel = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						Text = p17[k],
						Font = CaptionBodyFont,
						TextSize = v74,
						TextColor3 = v101 and p10.Theme.Alert.Color or p10.Theme.TextDefault.Color,
						TextTransparency = contentTransparency,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			end

			if height then
				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, height),
					BackgroundTransparency = 1,
					[Roact.Ref] = p9.containerRef,
					Position = v76:map(function(p19) -- line: 459
						return UDim2.new(0, 19 * -p19, 0, 0)
					end)
				}, t8)
			end

			return Roact.createElement(FitChildren.FitFrame, {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Ref] = p9.containerRef,
				Position = v76:map(function(p20) -- line: 469
					return UDim2.new(0, 19 * -p20, 0, 0)
				end)
			}, t8)
		end)
	end)
end

local v26 = RoactRodux.connect(nil, function(p21) -- line: 478
	return {
		validate = function(p22, p23, p24, p25, p26) -- line: 480
			-- upvalues: p21 (copy)
			return p21(p23(p22, p24, p25, p26))
		end
	}
end)(v22)

return (RoactServices.connect({
	networking = RoactNetworking
})(v26))
