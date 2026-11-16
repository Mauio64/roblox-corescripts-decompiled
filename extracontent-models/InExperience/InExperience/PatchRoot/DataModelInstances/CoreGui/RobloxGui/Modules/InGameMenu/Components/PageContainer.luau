local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local Otter = InGameMenuDependencies.Otter
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent

local BlurredModalPortal = require(script.Parent.BlurredModalPortal)
local Pages = require(script.Parent.Pages)

local Constants = require(script.Parent.Parent.Resources.Constants)

local components = {}

for k, page in pairs(Pages.pagesByKey) do
	local component = require(page.component)
	components[k] = component
end

local withLocalization = require(parent.Localization.withLocalization)

local extended = Roact.PureComponent:extend("PageContainer")
extended.validateProps = t.strictInterface({
	currentPage = t.string,
	visible = t.boolean,
	controllerBarHeight = t.number,
	controllerBarCount = t.number
})

function extended:init(p)
	function self.onContainerRendered(p2, p3)
		if p2 then
			local selectionParentNameFromKey = self.getSelectionParentNameFromKey(p3)
			GuiService:RemoveSelectionGroup(selectionParentNameFromKey)
			GuiService:AddSelectionParent(selectionParentNameFromKey, p2)
		end
	end

	function self.getSelectionParentNameFromKey(p2)
		return p2 .. "_IGMPageSelectionGroup"
	end

	self.pagePositions = {}
	self.pageVisibilities = {}
	local bindings = {}
	local v = {}
	local v2 = {}

	for k, _ in pairs(Pages.pagesByKey) do
		local v3 = p.currentPage == k and 1 or 0
		local binding, v4 = Roact.createBinding(v3)
		bindings[k] = binding
		v[k] = v4
		v2[k] = v3

		self.pagePositions[k] = bindings[k]:map(function(p2)
			return UDim2.new(p2 - 1, 0, 0, 0)
		end)

		self.pageVisibilities[k] = bindings[k]:map(function(p2): boolean
			return p2 ~= 0 and p2 ~= 1.25
		end)
	end

	self.pageMotor = Otter.createGroupMotor(v2)
	self.pageMotor:onStep(function(items)
		for k, item in pairs(items) do
			v[k](item)
		end
	end)
end

function extended.render(props)
	local v = {}

	for k, page in pairs(Pages.pagesByKey) do
		local pageVisibility = props.pageVisibilities[k]

		v[k] = withLocalization({ title = page.title })(function(p)
			if page.isModal then
				return Roact.createElement(BlurredModalPortal, {
					Enabled = props.props.currentPage == k
				}, {
					ModalPageContent = Roact.createElement(components[k], { pageTitle = p.title })
				})
			end

			return Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = props.pagePositions[k],
				BackgroundTransparency = 1,
				ZIndex = page.navigationDepth,
				Visible = pageVisibility,
				[Roact.Ref] = function(p2)
					props.onContainerRendered(p2, k)
				end
			}, {
				Page = Roact.createElement(components[k], {
					pageTitle = page.title and p.title
				})
			})
		end)
	end

	local v2 = props.props.controllerBarCount > 0 and -1 * Constants.ControllerBarHeight or nil
	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 400, 1, v2),
		Position = UDim2.new(0, 64, 0, 0),
		BackgroundTransparency = 1,
		Visible = props.props.visible,
		ClipsDescendants = true
	}, v)
end

function extended.didUpdate(p, p2, _)
	local v = p2.currentPage
	local currentPage = p.props.currentPage

	if v ~= currentPage then
		local isModal = Pages.pagesByKey[currentPage].isModal
		local isModal2 = Pages.pagesByKey[v].isModal

		if isModal or isModal2 then
			return
		end

		if Pages.pagesByKey[v].navigationDepth < Pages.pagesByKey[currentPage].navigationDepth then
			if not isModal then
				p.pageMotor:setGoal({
					[v] = Otter.spring(1.25, { frequency = 2.5 })
				})
			end
		elseif Pages.pagesByKey[v].navigationDepth == Pages.pagesByKey[currentPage].navigationDepth then
			p.pageMotor:setGoal({
				[v] = Otter.spring(0, { frequency = 2.5 })
			})
		else
			local values = {}

			while v ~= nil and v ~= currentPage do
				values[v] = Otter.spring(0, { frequency = 3.5 })
				v = Pages.pagesByKey[v].parentPage
			end

			p.pageMotor:setGoal(values)
		end

		p.pageMotor:setGoal({
			[currentPage] = Otter.spring(1, { frequency = 2.5 })
		})
	end
end

function extended.willUnmount(p)
	for k, page in pairs(Pages.pagesByKey) do
		if not page.isModal then
			GuiService:RemoveSelectionGroup((p.getSelectionParentNameFromKey(k)))
		end
	end
end

return RoactRodux.UNSTABLE_connect2(function(data)
	return {
		currentPage = data.menuPage,
		visible = data.isMenuOpen,
		controllerBarHeight = data.controllerBarHeight,
		controllerBarCount = data.controllerBarCount
	}
end)(extended)
