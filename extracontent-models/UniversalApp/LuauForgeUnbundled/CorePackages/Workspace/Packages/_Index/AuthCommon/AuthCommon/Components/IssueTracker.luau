local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactRodux")
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags").RoactNetworking

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/t")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/tutils")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").withLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitChildren")
local FitTextLabel = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitTextLabel")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/Logger")

local IssueCondition = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/IssueCondition")
local InputValidity = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/InputValidity")

local binding = Roact.createBinding(0)

local interface = t.interface({
	validateFunction = t.callback,
	getIssueMessageList = t.callback,
	getDefaultIssues = t.callback
})

local extended = Roact.PureComponent:extend("IssueTracker")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags")
local fFlagSignUpTrackFailedRequest = SharedFlags.FFlagSignUpTrackFailedRequest
local fFlagAuthValidatorStyleOverrides = SharedFlags.FFlagAuthValidatorStyleOverrides
local GetFFlagIssueTrackerUseFoundationIcon = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/GetFFlagIssueTrackerUseFoundationIcon")

function extended:init()
	local validator = self.props.validator

	assert(interface(validator))

	local issueMessageList = validator.getIssueMessageList()
	local defaultIssues = validator.getDefaultIssues()

	local v5 = {}

	for k in pairs(issueMessageList) do
		v5[k] = defaultIssues[k] ~= IssueCondition.Hidden
	end

	self.state = {
		listOfIssuesOnDisplay = v5,
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

		validate(
			networking,
			validator.validateFunction,
			textToValidate,
			issueCondition,
			validatorAdditionalProps
		):andThen(
			function(data)
				spawn(function()
					local onTextValidated = self.props.onTextValidated
					local textToValidate2 = self.props.textToValidate
					local v6 = InputValidity.Invalid

					if self.isMounted and data.Input == textToValidate2 then
						if textToValidate2 == "" then
							v6 = InputValidity.Unvalidated
						elseif data.InputValid then
							v6 = InputValidity.Valid
						end

						if onTextValidated then
							if fFlagSignUpTrackFailedRequest then
								onTextValidated(data.Input, v6, data.hasRequestFailed)
							else
								onTextValidated(data.Input, v6)
							end
						end

						self:setState({
							issueCondition = data.IssueCondition,
							inputValidity = v6
						})

						if self.props.updateIssueCondition then
							self.props.updateIssueCondition(data.IssueCondition)
						end
					end
				end)
			end,
			function(p2)
				Logger:warning(string.format("Input issueTracker error: %s", (tostring(p2))))
				self:setState({ inputValidity = InputValidity.Unvalidated })
			end
		)
	end

	function self.updateListOfIssuesOnDisplay()
		local height = self.props.height

		local issueMessageList2 = self.state.issueMessageList
		local issueCondition = self.state.issueCondition

		local children = self.containerRef.current and self.containerRef.current:GetChildren() or {}
		local v6 = {}
		local v7 = {}

		local v8 = {}
		local total = 0
		local v9 = {}

		for k, guiObject in pairs(children) do
			if guiObject:IsA("GuiObject") then
				v6[guiObject.Name] = guiObject.AbsoluteSize.Y
			end
		end

		for k in pairs(issueMessageList2) do
			v7[k] = false

			local v10 = issueCondition[k] == IssueCondition.Problematic

			if issueCondition[k] == IssueCondition.Hidden then
				continue
			end

			local v11 = v6[k] or 0
			table.insert(v8, k)
			total += v11

			if not v10 then
				table.insert(v9, #v8)
			end
		end

		local v10 = total + (#v8 - 1) * 5

		if height then
			for i = #v9, 1, -1 do
				if height < v10 then
					local v11 = v9[i]
					v10 = v10 - (v6[v8[v11]] or 0) - 5
					table.remove(v8, v11)
				else
					break
				end
			end

			for i = #v8, 1, -1 do
				if height < v10 then
					v10 = v10 - (v6[v8[i]] or 0) - 5
					table.remove(v8, i)
				else
					break
				end
			end
		end

		for k, v11 in pairs(v8) do
			v7[v11] = true
		end

		spawn(function()
			if self.isMounted and not tutils.shallowEqual(v7, self.state.listOfIssuesOnDisplay) then
				self:setState({ listOfIssuesOnDisplay = v7 })
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

function extended.didUpdate(data, data2, p2)
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
			if fFlagSignUpTrackFailedRequest then
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

	return withStyle(function(p2)
		local font = p2.Font.CaptionBody.Font
		local v5 = p2.Font.BaseSize * p2.Font.CaptionBody.RelativeSize
		local v6 = self.props.contentTransparency
		local checkmarkTransparency = self.props.checkmarkTransparency or binding
		local v7

		if fFlagAuthValidatorStyleOverrides and self.props.colorContentOverride then
			v7 = self.props.colorContentOverride
		else
			v7 = p2.Theme.TextDefault.Color
		end

		if not v6 then
			local transparency = p2.Theme.TextDefault.Transparency

			if transparency ~= self.textDefaultTransparency then
				self.textDefaultTransparency = transparency
				self.textDefaultTransparencyBinding = Roact.createBinding(transparency)
			end

			v6 = self.textDefaultTransparencyBinding
		end

		local joinBindings = Roact.joinBindings({
			content = v6,
			checkmark = checkmarkTransparency
		})

		local v8 = {}

		for k in pairs(issueMessageList) do
			table.insert(v8, k)
		end

		if self.props.sortProblematicIssues then
			table.sort(v8, function(a, b): boolean
				return issueCondition[a] == IssueCondition.Problematic
					and issueCondition[b] ~= IssueCondition.Problematic
			end)
		end

		return withLocalization(issueMessageList)(function(p3)
			local children = { Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					[Roact.Change.AbsoluteContentSize] = self.updateListOfIssuesOnDisplay
				}) }

			for i, v9 in ipairs(v8) do
				local v10 = issueCondition[v9] == IssueCondition.Problematic
				local v11 = v10 and self.state.inputValidity ~= InputValidity.Unvalidated

				local createElement2 = Roact.createElement
				local fitFrame = FitChildren.FitFrame
				local v12 = {
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					LayoutOrder = i,
					Visible = listOfIssuesOnDisplay[v9]
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

				local createElement3 = Roact.createElement
				local v14 = {
					Size = UDim2.new(0, 12, 0, 12),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				}
				local v16

				if GetFFlagIssueTrackerUseFoundationIcon() then
					local createElement4 = Roact.createElement
					local v19 = if v10 then iconName.X else iconName.Check
					v16 = createElement4(icon, {
						name = v19,
						variant = iconVariant.Filled,
						size = iconSize.XSmall,
						style = joinBindings:map(function(p4)
							return {
								Color3 = v11 and p2.Theme.Alert.Color or v7,
								Transparency = (p4.content - 1) * (1 - p4.checkmark) + 1
							}
						end),
						Position = UDim2.new(0.5, 0, 0.65, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				else
					local createElement4 = Roact.createElement

					local v19 = if v10 then getImageData("LuaApp/icons/navigation/close") or "LuaApp/icons/navigation/close" else getImageData("LuaApp/icons/progress_small") or "LuaApp/icons/progress_small"
					v16 = createElement4(imageSetLabel, {
						BackgroundTransparency = 1,
						Image = v19,
						ImageColor3 = v11 and p2.Theme.Alert.Color or v7,
						ImageTransparency = joinBindings:map(function(p4)
							return (p4.content - 1) * (1 - p4.checkmark) + 1
						end),
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0.65, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				end

				children2.CheckHolder = createElement3("Frame", v14, { CheckMark = v16 })

				children2.IssueLabel = Roact.createElement(FitTextLabel, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					Text = p3[v9],
					TextWrapped = true,
					Font = font,
					TextSize = v5,
					TextColor3 = v11 and p2.Theme.Alert.Color or v7,
					TextTransparency = v6,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				children[v9] = createElement2(fitFrame, v12, children2)
			end

			if height then
				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, height),
					BackgroundTransparency = 1,
					[Roact.Ref] = self.containerRef,
					Position = checkmarkTransparency:map(function(p4)
						return UDim2.new(0, 19 * -p4, 0, 0)
					end)
				}, children)
			end

			return Roact.createElement(FitChildren.FitFrame, {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Ref] = self.containerRef,
				Position = checkmarkTransparency:map(function(p4)
					return UDim2.new(0, 19 * -p4, 0, 0)
				end)
			}, children)
		end)
	end)
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		validate = function(self, callback2, p3, p4, p5)
			return callback(callback2(self, p3, p4, p5))
		end
	}
end)(extended)

return (roactServices.connect({ networking = roactNetworking })(v5))
