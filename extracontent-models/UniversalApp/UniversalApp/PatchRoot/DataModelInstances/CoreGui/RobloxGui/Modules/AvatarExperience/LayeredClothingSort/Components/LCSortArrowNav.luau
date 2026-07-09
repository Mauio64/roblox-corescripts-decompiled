local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local SetOrder = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetOrder)
local SetOrderForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetOrderForTryOns
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local LayeredClothingSortUtils = require(Modules.AvatarExperience.LayeredClothingSort.LayeredClothingSortUtils)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v21 = Images["icons/navigation/cycleUp"]
local v22 = Images["icons/navigation/cycleDown"]
local v23 = Roact.PureComponent:extend("LCSortArrowNav")

v23.validateProps = t.strictInterface({
	Visible = t.union(t.boolean, t.table),
	index = t.number,
	asset = t.table,
	currentSort = t.table,
	equippedAssets = t.table,
	tryOnItems = t.table,
	lookType = t.optional(t.string),
	setOrder = t.callback,
	setOrderForTryOns = t.callback,
	setCurrentSort = t.callback,
	sendAnalytics = t.callback,
	analytics = t.table
})

function v23.moveTile(p1, p2) -- line: 69
	-- upvalues: LayeredClothingSortUtils (copy)
	local t1 = {}

	for v30, v31 in p1.props.currentSort do
		if v30 ~= p1.props.index then
			table.insert(t1, v31)
		end
	end

	local t2 = {
		id = p1.props.asset.id,
		typeId = p1.props.asset.typeId
	}

	table.insert(t1, p1.props.index + p2, t2)

	local v33, v34 = LayeredClothingSortUtils.formatForSetOrderWithTryOns(t1, p1.props.equippedAssets, p1.props.tryOnItems, p1.props.lookType)

	p1.props.setOrder(v33)
	p1.props.setOrderForTryOns(v34)
	p1.props.setCurrentSort(t1)
	p1.props.sendAnalytics(p1.props.analytics.avatarRefineAutosaved)
end
function v23.init(p3) -- line: 100
	-- upvalues: Roact (copy)
	p3.animLoopConn = nil
	p3.animOutConn = nil
	p3.animInConn = nil
	p3.animating = false

	local v36, v37 = Roact.createBinding(UDim2.fromOffset(0, 4))

	p3.upArrowPos = v36
	p3.updateUpArrowPos = v37

	local v38, v39 = Roact.createBinding(UDim2.fromScale(0, 0))

	p3.downArrowPos = v38
	p3.updateDownArrowPos = v39

	function p3.onUpActivated() -- line: 108
		-- upvalues: p3 (copy)
		p3:moveTile(-1)
	end
	function p3.onDownActivated() -- line: 112
		-- upvalues: p3 (copy)
		p3:moveTile(1)
	end
end
function v23.animateOut(p4) -- line: 123
	-- upvalues: RunService (copy)
	local n1 = 4
	local n2 = 0

	p4.animOutConn = RunService.RenderStepped:connect(function(p5) -- line: 126
		-- upvalues: n1 (ref), n2 (ref), p4 (copy)
		n1 -= p5 * 14
		n2 += p5 * 14

		local v58 = math.max(n1, 0)
		local v59 = math.min(n2, 4)

		p4.updateUpArrowPos(UDim2.new(0, 0, 0, v58))
		p4.updateDownArrowPos(UDim2.new(0, 0, 0, v59))

		if v58 == 0 then
			p4.animOutConn:Disconnect()
			p4.animOutConn = nil
			p4:animateIn()
		end
	end)
end
function v23.animateIn(p6) -- line: 149
	-- upvalues: RunService (copy)
	local n3 = 0
	local n4 = 4

	p6.animInConn = RunService.RenderStepped:connect(function(p7) -- line: 152
		-- upvalues: n3 (ref), n4 (ref), p6 (copy)
		n3 += p7 * 14
		n4 -= p7 * 14

		local v61 = math.min(n3, 4)
		local v62 = math.max(n4, 0)

		p6.updateUpArrowPos(UDim2.new(0, 0, 0, v61))
		p6.updateDownArrowPos(UDim2.new(0, 0, 0, v62))

		if v61 == 4 then
			p6.animInConn:Disconnect()
			p6.animInConn = nil
			p6.timeOfLastAnimation = tick()
			p6.animating = false
		end
	end)
end
function v23.render(p8) -- line: 169
	-- upvalues: withStyle (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), ImageSetLabel (copy), v21 (copy), v22 (copy)
	return withStyle(function(p9) -- line: 170
		-- upvalues: p8 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), ImageSetLabel (copy), v21 (copy), v22 (copy)
		local Theme = p9.Theme
		local v65 = p8.props.Visible and p8.props.index ~= 1
		local v66 = p8.props.Visible and p8.props.index ~= #p8.props.currentSort

		return Roact.createFragment({
			UpArrowButton = Roact.createElement("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Visible = v65,
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil,
				Size = UDim2.fromOffset(Constants.Tile.ArrowSize.X.Offset, Constants.Tile.ArrowSize.Y.Offset + 4),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 0),
				[Roact.Event.Activated] = p8.onUpActivated
			}, {
				UpArrowIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = Constants.Tile.ArrowSize,
					Position = p8.upArrowPos,
					Image = v21,
					ImageColor3 = Theme.IconEmphasis.Color
				})
			}),
			DownArrowButton = Roact.createElement("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Visible = v66,
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil,
				Size = UDim2.fromOffset(Constants.Tile.ArrowSize.X.Offset, Constants.Tile.ArrowSize.Y.Offset + 4),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, Constants.Tile.SelectedSize),
				[Roact.Event.Activated] = p8.onDownActivated
			}, {
				DownArrowIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = Constants.Tile.ArrowSize,
					Position = p8.downArrowPos,
					Image = v22,
					ImageColor3 = Theme.IconEmphasis.Color
				})
			})
		})
	end)
end
function v23.didMount(p10) -- line: 223
	-- upvalues: RunService (copy)
	p10.timeOfLastAnimation = tick()
	p10.animLoopConn = RunService.RenderStepped:connect(function(_) -- line: 229
		-- upvalues: p10 (copy)
		if tick() - p10.timeOfLastAnimation >= 1 and not p10.animating then
			p10.animating = true
			p10:animateOut()
		end
	end)
end
function v23.willUnmount(p12) -- line: 238
	if p12.animLoopConn then
		p12.animLoopConn:Disconnect()
		p12.animLoopConn = nil
	end

	if p12.animOutConn then
		p12.animOutConn:Disconnect()
		p12.animOutConn = nil
	end

	if p12.animInConn then
		p12.animInConn:Disconnect()
		p12.animInConn = nil
	end
end

local function mapStateToProps(p13, _) -- line: 255
	local t3 = {
		currentSort = p13.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList,
		equippedAssets = p13.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		tryOnItems = p13.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	}
	local lookType = nil
	local Looks = p13.AvatarExperience.AvatarScene.Looks
	local LookId = p13.AvatarExperience.AvatarScene.OutfitTryOn.LookId

	if LookId ~= nil and Looks ~= nil then
		local v55 = Looks[LookId]

		if v55 then
			lookType = v55.lookType
		end
	end

	t3.lookType = lookType

	return t3
end
local function mapDispatchToProps(p15) -- line: 277
	-- upvalues: SetOrder (copy), SetOrderForTryOns (copy), SetCurrentSort (copy), SendRefinementAnalytics (copy)
	return {
		setOrder = function(p16) -- line: 279
			-- upvalues: p15 (copy), SetOrder (copy)
			p15(SetOrder(p16))
		end,
		setOrderForTryOns = function(p17) -- line: 282
			-- upvalues: p15 (copy), SetOrderForTryOns (copy)
			p15(SetOrderForTryOns(p17))
		end,
		setCurrentSort = function(p18) -- line: 285
			-- upvalues: p15 (copy), SetCurrentSort (copy)
			p15(SetCurrentSort(p18))
		end,
		sendAnalytics = function(p19) -- line: 288
			-- upvalues: p15 (copy), SendRefinementAnalytics (copy)
			p15(SendRefinementAnalytics(p19))
		end
	}
end

local v26 = RoactServices.connect({
	analytics = Analytics
})(v23)

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v26))
