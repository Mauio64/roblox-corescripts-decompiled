local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local Otter = InGameMenuDependencies.Otter
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local BlurredModalPortal = require(script.Parent.BlurredModalPortal)
local Pages = require(script.Parent.Pages)
local Constants = require(script.Parent.Parent.Resources.Constants)
local t1 = {}

for k, v in pairs(Pages.pagesByKey) do
	t1[k] = require(v.component)
end

local withLocalization = require(ParentParent.Localization.withLocalization)
local v16 = Roact.PureComponent:extend("PageContainer")

v16.validateProps = t.strictInterface({
	currentPage = t.string,
	visible = t.boolean,
	controllerBarHeight = t.number,
	controllerBarCount = t.number
})

function v16.init(p1, p2) -- line: 34
	-- upvalues: GuiService (copy), Pages (copy), Roact (copy), Otter (copy)
	function p1.onContainerRendered(p3, p4) -- line: 35
		-- upvalues: p1 (copy), GuiService (copy)
		if p3 then
			local v48 = p1.getSelectionParentNameFromKey(p4)

			GuiService:RemoveSelectionGroup(v48)
			GuiService:AddSelectionParent(v48, p3)
		end
	end
	function p1.getSelectionParentNameFromKey(p5) -- line: 43
		return p5 .. "_IGMPageSelectionGroup"
	end

	local t2 = {}
	local t3 = {}
	local t4 = {}

	p1.pagePositions = {}
	p1.pageVisibilities = {}

	for k, _ in pairs(Pages.pagesByKey) do
		local v24 = k ~= p2.currentPage and 0 or 1
		local v25, v26 = Roact.createBinding(v24)

		t2[k] = v25
		t3[k] = v26
		t4[k] = v24
		p1.pagePositions[k] = t2[k]:map(function(p6) -- line: 55
			return UDim2.new(p6 - 1, 0, 0, 0)
		end)
		p1.pageVisibilities[k] = t2[k]:map(function(p7) -- line: 60
			if p7 == 0 or p7 == 1.25 then
				return false
			end

			return true
		end)
	end

	p1.pageMotor = Otter.createGroupMotor(t4)
	p1.pageMotor:onStep(function(p8) -- line: 69
		-- upvalues: t3 (copy)
		for k, v in pairs(p8) do
			t3[k](v)
		end
	end)
end
function v16.render(p9) -- line: 76
	-- upvalues: Pages (copy), withLocalization (copy), Roact (copy), t1 (copy), BlurredModalPortal (copy), Constants (copy)
	local t5 = {}

	for k, v in pairs(Pages.pagesByKey) do
		local v31 = p9.pageVisibilities[k]

		t5[k] = withLocalization({
			title = v.title
		})(function(p10) -- line: 84
			-- upvalues: v (copy), Roact (copy), p9 (copy), k (copy), v31 (copy), t1 (copy), BlurredModalPortal (copy)
			if not v.isModal then
				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					Position = p9.pagePositions[k],
					BackgroundTransparency = 1,
					ZIndex = v.navigationDepth,
					Visible = v31,
					[Roact.Ref] = function(p11) -- line: 92
						-- upvalues: p9 (copy), k (copy)
						p9.onContainerRendered(p11, k)
					end
				}, {
					Page = Roact.createElement(t1[k], {
						pageTitle = v.title and p10.title
					})
				})
			end

			return Roact.createElement(BlurredModalPortal, {
				Enabled = p9.props.currentPage == k
			}, {
				ModalPageContent = Roact.createElement(t1[k], {
					pageTitle = p10.title
				})
			})
		end)
	end

	local v32 = p9.props.controllerBarCount > 0 and -1 * Constants.ControllerBarHeight or nil

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(0, 400, 1, v32),
		Position = UDim2.new(0, 64, 0, 0),
		Visible = p9.props.visible
	}, t5)
end
function v16.didUpdate(p12, p13, _) -- line: 122
	-- upvalues: Pages (copy), Otter (copy)
	local currentPage = p13.currentPage
	local currentPage2 = p12.props.currentPage

	if currentPage ~= currentPage2 then
		local isModal = Pages.pagesByKey[currentPage2].isModal
		local isModal2 = Pages.pagesByKey[currentPage].isModal

		if isModal or isModal2 then
			return
		end

		if Pages.pagesByKey[currentPage].navigationDepth < Pages.pagesByKey[currentPage2].navigationDepth then
			if not isModal then
				p12.pageMotor:setGoal({
					[currentPage] = Otter.spring(1.25, {
						frequency = 2.5
					})
				})
			end
		elseif Pages.pagesByKey[currentPage].navigationDepth == Pages.pagesByKey[currentPage2].navigationDepth then
			p12.pageMotor:setGoal({
				[currentPage] = Otter.spring(0, {
					frequency = 2.5
				})
			})
		else
			local t6 = {}

			while currentPage ~= nil and currentPage ~= currentPage2 do
				t6[currentPage] = Otter.spring(0, {
					frequency = 3.5
				})
				currentPage = Pages.pagesByKey[currentPage].parentPage
			end

			p12.pageMotor:setGoal(t6)
		end

		p12.pageMotor:setGoal({
			[currentPage2] = Otter.spring(1, {
				frequency = 2.5
			})
		})
	end
end
function v16.willUnmount(p15) -- line: 165
	-- upvalues: Pages (copy), GuiService (copy)
	for k, v in pairs(Pages.pagesByKey) do
		if not v.isModal then
			local v44 = p15.getSelectionParentNameFromKey(k)

			GuiService:RemoveSelectionGroup(v44)
		end
	end
end

return RoactRodux.UNSTABLE_connect2(function(p16) -- line: 174
	return {
		currentPage = p16.menuPage,
		visible = p16.isMenuOpen,
		controllerBarHeight = p16.controllerBarHeight,
		controllerBarCount = p16.controllerBarCount
	}
end)(v16)
