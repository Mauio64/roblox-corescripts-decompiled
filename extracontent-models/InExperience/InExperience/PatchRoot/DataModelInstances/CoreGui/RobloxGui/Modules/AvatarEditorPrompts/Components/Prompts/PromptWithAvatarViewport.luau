local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local InteractiveAlert = require(CorePackages.Packages.UIBlox).App.Dialog.Alert.InteractiveAlert
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local HumanoidViewport = require(ParentParent.HumanoidViewport)
local GetConformedHumanoidDescription = require(ParentParentParent.GetConformedHumanoidDescription)
local v10 = Roact.PureComponent:extend("PromptWithAvatarViewport")

v10.validateProps = t.strictInterface({
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	title = t.string,
	bodyText = t.optional(t.string),
	buttonStackInfo = t.table,
	screenSize = t.Vector2
})

function v10.init(p1) -- line: 41
	-- upvalues: Roact (copy)
	p1.mounted = false
	p1.middleContentRef = Roact.createRef()

	local v13, v14 = Roact.createBinding(UDim2.new(1, 0, 0, 200))

	p1.contentSize = v13
	p1.updateContentSize = v14
	p1:setState({
		conformedHumanoidDescription = nil,
		getConformedDescriptionFailed = false
	})

	function p1.onAlertSizeChanged(p2) -- line: 52
		-- upvalues: p1 (copy)
		local AbsoluteSize = p2.AbsoluteSize

		if not p1.middleContentRef:getValue() then
			return
		end

		local AbsoluteSizeY = p1.middleContentRef:getValue().AbsoluteSize.Y
		local v30 = AbsoluteSize.Y - AbsoluteSizeY
		local v31 = p1.props.screenSize.Y - 60 - v30
		local v32 = p1.middleContentRef:getValue().AbsoluteSize.X - 20

		if v32 < v31 then
			v31 = v32
		end

		if AbsoluteSizeY ~= v31 then
			p1.updateContentSize(UDim2.new(1, 0, 0, v31))
		end
	end
	function p1.retryLoadDescription() -- line: 74
		-- upvalues: p1 (copy)
		p1:setState({
			getConformedDescriptionFailed = false
		})
		p1:getConformedHumanoidDescription()
	end
end
function v10.renderAlertMiddleContent(p3) -- line: 83
	-- upvalues: Roact (copy), HumanoidViewport (copy)
	local conformedHumanoidDescription = p3.state.conformedHumanoidDescription
	local getConformedDescriptionFailed = p3.state.getConformedDescriptionFailed

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p3.contentSize,
		[Roact.Ref] = p3.middleContentRef
	}, {
		HumanoidViewport = Roact.createElement(HumanoidViewport, {
			humanoidDescription = conformedHumanoidDescription,
			loadingFailed = getConformedDescriptionFailed,
			retryLoadDescription = p3.retryLoadDescription,
			rigType = p3.props.rigType
		})
	})
end
function v10.render(p4) -- line: 102
	-- upvalues: Roact (copy), InteractiveAlert (copy)
	return Roact.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		title = p4.props.title,
		bodyText = p4.props.bodyText,
		buttonStackInfo = p4.props.buttonStackInfo,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p4.props.screenSize,
		middleContent = function() -- line: 109
			-- upvalues: p4 (copy)
			return p4:renderAlertMiddleContent()
		end,
		onAbsoluteSizeChanged = p4.onAlertSizeChanged
	})
end
function v10.getConformedHumanoidDescription(p5, p6) -- line: 117
	-- upvalues: GetConformedHumanoidDescription (copy)
	GetConformedHumanoidDescription(p6, true):andThen(function(p7) -- line: 119
		-- upvalues: p5 (copy)
		if not p5.mounted then
			return
		end

		p5:setState({
			conformedHumanoidDescription = p7
		})
	end, function(_) -- line: 127
		-- upvalues: p5 (copy)
		if not p5.mounted then
			return
		end

		p5:setState({
			getConformedDescriptionFailed = true
		})
	end)
end
function v10.didMount(p9) -- line: 138
	p9.mounted = true
	p9:getConformedHumanoidDescription(p9.props.humanoidDescription)
end
function v10.didUpdate(p10, p11, _) -- line: 144
	-- upvalues: Roact (copy)
	if p11.humanoidDescription ~= p10.props.humanoidDescription then
		p10:setState({
			getConformedDescriptionFailed = false,
			conformedHumanoidDescription = Roact.None
		})
		p10:getConformedHumanoidDescription(p10.props.humanoidDescription)
	end
end
function v10.willUnmount(p13) -- line: 155
	p13.mounted = false
end

local function mapStateToProps(p14) -- line: 159
	return {
		screenSize = p14.screenSize
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(v10))
