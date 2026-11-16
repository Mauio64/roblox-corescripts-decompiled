local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking

local t = require(parent.t)
local tutils = require(parent.tutils)
local ArgCheck = require(parent.ArgCheck)

local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

local FitChildren = require(AuthCommon.Components.FitChildren)
local FitTextLabel = require(AuthCommon.Components.FitTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData

local Logger = require(AuthCommon.Components.Logger)

local IssueCondition = require(AuthCommon.Enums.IssueCondition)
local InputValidity = require(AuthCommon.Enums.InputValidity)

local binding = Roact.createBinding(0)

local interface = t.interface({
	validateFunction = t.callback,
	getIssueMessageList = t.callback,
	getDefaultIssues = t.callback
})

local extended = Roact.PureComponent:extend("IssueTracker")

local SharedFlags = require(parent.SharedFlags)
local FFlagSignUpTrackFailedRequest = SharedFlags.FFlagSignUpTrackFailedRequest
local FFlagAuthValidatorStyleOverrides = SharedFlags.FFlagAuthValidatorStyleOverrides
local GetFFlagIssueTrackerUseFoundationIcon = require(AuthCommon.Flags.GetFFlagIssueTrackerUseFoundationIcon)

function extended:init()
	local validator = self.props.validator

	assert(interface(validator))

	local issueMessageList = validator.getIssueMessageList()
	local defaultIssues = validator.getDefaultIssues()

	local listOfIssuesOnDisplay = {}

	for k in pairs(issueMessageList) do
		listOfIssuesOnDisplay[k] = defaultIssues[k] ~= IssueCondition.Hidden
	end

	self.state = {
		listOfIssuesOnDisplay = listOfIssuesOnDisplay,
		issueMessageList = issueMessageList,
		issueCondition = defaultIssues,
		inputValidity = InputValidity.Unvalidated
	}

	self.isMounted = false
	self.containerRef = Roact.createRef()

	function self.validateText()
		local networking = self.props.networking

		local textToValidate = self.props.textToValidate
		local validate = self.props.validate
		local validatorAdditionalProps = self.props.validatorAdditionalProps
		local issueCondition = self.state.issueCondition

		assert(interface(validator))

		validate(networking, validator.validateFunction, textToValidate, issueCondition, validatorAdditionalProps):andThen(
			function(data)
				spawn(function()
					local onTextValidated = self.props.onTextValidated
					local textToValidate2 = self.props.textToValidate
					local inputValidity = InputValidity.Invalid

					if self.isMounted and data.Input == textToValidate2 then
						if textToValidate2 == "" then
							inputValidity = InputValidity.Unvalidated
						elseif data.InputValid then
							inputValidity = InputValidity.Valid
						end

						if onTextValidated then
							if FFlagSignUpTrackFailedRequest then
								onTextValidated(data.Input, inputValidity, data.hasRequestFailed)
							else
								onTextValidated(data.Input, inputValidity)
							end
						end

						self:setState({
							issueCondition = data.IssueCondition,
							inputValidity = inputValidity
						})

						if self.props.updateIssueCondition then
							self.props.updateIssueCondition(data.IssueCondition)
						end
					end
				end)
			end,
			function(p)
				Logger:warning(string.format("Input issueTracker error: %s", (tostring(p))))
				self:setState({ inputValidity = InputValidity.Unvalidated })
			end
		)
	end

	function self.updateListOfIssuesOnDisplay()
		local height = self.props.height

		local issueMessageList2 = self.state.issueMessageList
		local issueCondition = self.state.issueCondition

		local children = self.containerRef.current and self.containerRef.current:GetChildren() or {}
		local v = {}
		local listOfIssuesOnDisplay2 = {}

		local v2 = {}
		local total = 0
		local v3 = {}

		for _, guiObject in pairs(children) do
			if guiObject:IsA("GuiObject") then
				v[guiObject.Name] = guiObject.AbsoluteSize.Y
			end
		end

		for k in pairs(issueMessageList2) do
			listOfIssuesOnDisplay2[k] = false

			local v4 = issueCondition[k] == IssueCondition.Problematic

			if issueCondition[k] == IssueCondition.Hidden then
				continue
			end

			local v5 = v[k] or 0
			table.insert(v2, k)
			total += v5

			if not v4 then
				table.insert(v3, #v2)
			end
		end

		local v4 = total + (#v2 - 1) * 5

		if height then
			for i = #v3, 1, -1 do
				if height < v4 then
					local v5 = v3[i]
					v4 = v4 - (v[v2[v5]] or 0) - 5
					table.remove(v2, v5)
				else
					break
				end
			end

			for i = #v2, 1, -1 do
				if height < v4 then
					v4 = v4 - (v[v2[i]] or 0) - 5
					table.remove(v2, i)
				else
					break
				end
			end
		end

		for _, v5 in pairs(v2) do
			listOfIssuesOnDisplay2[v5] = true
		end

		spawn(function()
			if self.isMounted and not tutils.shallowEqual(listOfIssuesOnDisplay2, self.state.listOfIssuesOnDisplay) then
				self:setState({ listOfIssuesOnDisplay = listOfIssuesOnDisplay2 })
			end
		end)
	end
end

function extended:didMount()
	self.isMounted = true
	self.updateListOfIssuesOnDisplay()
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.didUpdate(data, data2, _)
	local validator = data.props.validator
	local validatorAdditionalProps = data.props.validatorAdditionalProps
	local textToValidate = data.props.textToValidate

	if validator ~= data2.validator then
		ArgCheck.assert(validator == data2.validator, "IssueTracker expects the validator to never change")
	end

	if
		textToValidate ~= data2.textToValidate
		or not tutils.shallowEqual(validatorAdditionalProps, data2.validatorAdditionalProps)
	then
		spawn(function()
			if FFlagSignUpTrackFailedRequest then
				task.wait(not data.props.debounceTime and 0.3 or data.props.debounceTime)
			else
				wait(0.3)
			end

			if textToValidate == data.props.textToValidate then
				data.validateText()
			end
		end)
	end

	data.updateListOfIssuesOnDisplay()
end

function extended:render()
	local height = self.props.height

	local issueMessageList = self.state.issueMessageList
	local issueCondition = self.state.issueCondition

	local listOfIssuesOnDisplay = self.state.listOfIssuesOnDisplay

	return withStyle(function(p)
		local font = p.Font.CaptionBody.Font
		local textSize = p.Font.BaseSize * p.Font.CaptionBody.RelativeSize
		local v = self.props.contentTransparency
		local checkmarkTransparency = self.props.checkmarkTransparency or binding
		local v2

		if FFlagAuthValidatorStyleOverrides and self.props.colorContentOverride then
			v2 = self.props.colorContentOverride
		else
			v2 = p.Theme.TextDefault.Color
		end

		if not v then
			local transparency = p.Theme.TextDefault.Transparency

			if transparency ~= self.textDefaultTransparency then
				self.textDefaultTransparency = transparency
				self.textDefaultTransparencyBinding = Roact.createBinding(transparency)
			end

			v = self.textDefaultTransparencyBinding
		end

		local joinBindings = Roact.joinBindings({ content = v, checkmark = checkmarkTransparency })

		local v3 = {}

		for k in pairs(issueMessageList) do
			table.insert(v3, k)
		end

		if self.props.sortProblematicIssues then
			table.sort(v3, function(a, b): boolean
				return issueCondition[a] == IssueCondition.Problematic
					and issueCondition[b] ~= IssueCondition.Problematic
			end)
		end

		return withLocalization(issueMessageList)(function(p2)
			local children = { Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					[Roact.Change.AbsoluteContentSize] = self.updateListOfIssuesOnDisplay
				}) }

			for i, v4 in ipairs(v3) do
				local v5 = issueCondition[v4] == IssueCondition.Problematic
				local v6 = v5 and self.state.inputValidity ~= InputValidity.Unvalidated

				local createElement = Roact.createElement
				local fitFrame = FitChildren.FitFrame
				local v7 = {
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					LayoutOrder = i,
					Visible = listOfIssuesOnDisplay[v4]
				}
				local children2 = {
					List = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 7),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					CheckHolder = 0,
					IssueLabel = 0
				}

				local createElement2 = Roact.createElement
				local v8 = {
					Size = UDim2.new(0, 12, 0, 12),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				}
				local checkMark

				if GetFFlagIssueTrackerUseFoundationIcon() then
					local createElement3 = Roact.createElement
					local name

					if v5 then
						name = IconName.X
					else
						name = IconName.Check
					end

					checkMark = createElement3(Icon, {
						name = name,
						variant = IconVariant.Filled,
						size = IconSize.XSmall,
						style = joinBindings:map(function(p3)
							return {
								Color3 = v6 and p.Theme.Alert.Color or v2,
								Transparency = (p3.content - 1) * (1 - p3.checkmark) + 1
							}
						end),
						Position = UDim2.new(0.5, 0, 0.65, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				else
					local createElement3 = Roact.createElement
					local image

					if v5 then
						image = GetImageData("LuaApp/icons/navigation/close") or "LuaApp/icons/navigation/close"
					else
						image = GetImageData("LuaApp/icons/progress_small") or "LuaApp/icons/progress_small"
					end

					checkMark = createElement3(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = image,
						ImageColor3 = v6 and p.Theme.Alert.Color or v2,
						ImageTransparency = joinBindings:map(function(p3)
							return (p3.content - 1) * (1 - p3.checkmark) + 1
						end),
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.65, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				end

				children2.CheckHolder = createElement2("Frame", v8, { CheckMark = checkMark })

				children2.IssueLabel = Roact.createElement(FitTextLabel, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					Text = p2[v4],
					TextWrapped = true,
					Font = font,
					TextSize = textSize,
					TextColor3 = v6 and p.Theme.Alert.Color or v2,
					TextTransparency = v,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				children[v4] = createElement(fitFrame, v7, children2)
			end

			if height then
				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, height),
					BackgroundTransparency = 1,
					[Roact.Ref] = self.containerRef,
					Position = checkmarkTransparency:map(function(p3)
						return UDim2.new(0, 19 * -p3, 0, 0)
					end)
				}, children)
			end

			return Roact.createElement(FitChildren.FitFrame, {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Ref] = self.containerRef,
				Position = checkmarkTransparency:map(function(p3)
					return UDim2.new(0, 19 * -p3, 0, 0)
				end)
			}, children)
		end)
	end)
end

local v = RoactRodux.connect(nil, function(callback)
	return {
		validate = function(p, callback2, p2, p3, p4)
			return callback(callback2(p, p2, p3, p4))
		end
	}
end)(extended)

return (roactServices.connect({ networking = RoactNetworking })(v))
