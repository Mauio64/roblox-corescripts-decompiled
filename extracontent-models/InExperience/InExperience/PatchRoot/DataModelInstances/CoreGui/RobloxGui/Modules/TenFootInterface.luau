local color = Color3.new(27 / 255, 252 / 255, 107 / 255)

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local tenFootInterface = AppCommonLib2.isTenFootInterface()

local function CreateModule()
	local module = {}
	module.Container = nil
	local states = {}
	local bindableEvent = Instance.new("BindableEvent")
	local bindableEvent2 = Instance.new("BindableEvent")

	local function createContainer()
		if not module.Container then
			module.Container = Create("ImageButton")({
				Name = "TopRightContainer",
				Size = UDim2.new(0, 350, 0, 100),
				Position = UDim2.new(1, -415, 0, 10),
				AutoButtonColor = false,
				Image = "",
				Active = false,
				BackgroundTransparency = 1,
				Parent = RobloxGui
			})
		end
	end

	function removeFromDisplayStack(p)
		local v = nil

		for i = 1, #states do
			if states[i] == p then
				v = i + 1
				break
			end
		end

		for i = v, #states do
			local v2 = states[i]
			v2.Position = UDim2.new(
				v2.Position.X.Scale,
				v2.Position.X.Offset,
				v2.Position.Y.Scale,
				p.AbsolutePosition.Y
			)
			p = v2
		end

		bindableEvent:Fire()
	end

	function addBackToDisplayStack(p)
		local v = 0

		for i = 1, #states do
			if states[i] == p then
				v = i + 1
				break
			end
		end

		for i = v, #states do
			local v2 = states[i]
			local v3 = p.AbsolutePosition.Y + p.AbsoluteSize.Y + 4
			v2.Position = UDim2.new(v2.Position.X.Scale, v2.Position.X.Offset, v2.Position.Y.Scale, v3)
			p = v2
		end

		bindableEvent:Fire()
	end

	function addToDisplayStack(state)
		local v

		if #states > 0 then
			v = states[#states]
		end

		states[#states + 1] = state

		local v2 = not v and 0 or v.AbsolutePosition.Y + v.AbsoluteSize.Y + 4

		state.Position = UDim2.new(state.Position.X.Scale, state.Position.X.Offset, state.Position.Y.Scale, v2)

		createContainer()
		state.Parent = module.Container

		state.Changed:connect(function(p)
			if p == "Visible" then
				if state.Visible then
					addBackToDisplayStack(state)
				else
					removeFromDisplayStack(state)
				end
			end
		end)
		bindableEvent:Fire()
	end

	function module:CreateHealthBar()
		module.HealthContainer = Create("Frame")({
			Name = "HealthContainer",
			Size = UDim2.new(1, -86, 0, 50),
			Position = UDim2.new(0, 92, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.5
		})

		local parent = Create("Frame")({
			Name = "HealthFillHolder",
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Parent = module.HealthContainer
		})

		local v = Create("Frame")({
			Name = "HealthFill",
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			BackgroundColor3 = color,
			Parent = parent
		})

		Create("TextLabel")({
			Name = "HealthText",
			Size = UDim2.new(0, 98, 0, 50),
			Position = UDim2.new(0, -100, 0, 0),
			BackgroundTransparency = 0.5,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size36,
			Text = "Health",
			TextColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Parent = module.HealthContainer
		})

		local v2 = Create("TextLabel")({ Visible = false })

		local v3 = Create("TextLabel")({ Visible = false })

		addToDisplayStack(module.HealthContainer)
		createContainer()

		module.HealthContainer.Changed:connect(function()
			bindableEvent2:Fire()
		end)

		return module.Container, v2, module.HealthContainer, v, v3
	end

	function module:CreateAccountType(text)
		module.AccountTypeContainer = Create("Frame")({
			Name = "AccountTypeContainer",
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.new(1, -55, 0, 10),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.5,
			Parent = RobloxGui
		})

		Create("TextLabel")({
			Name = "AccountTypeText",
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size36,
			Text = text,
			TextColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Parent = module.AccountTypeContainer,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	end

	function module:SetupTopStat()
		local v = true
		local v2 = nil
		local changedConnection = nil
		local ancestryChangedConnection = nil
		local childAddedConnection = nil
		local parent = nil

		local function makeTenFootInterfaceStat()
			if parent then
				return
			end

			parent = Create("Frame")({
				Name = "OneStatFrame",
				Size = UDim2.new(1, 0, 0, 36),
				Position = UDim2.new(0, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			})

			local statValue = Create("TextLabel")({
				Name = "StatName",
				Size = UDim2.new(0.5, 0, 0, 36),
				BackgroundTransparency = 1,
				Font = Enum.Font.SourceSans,
				FontSize = Enum.FontSize.Size36,
				TextStrokeColor3 = Color3.new(104 / 255, 104 / 255, 104 / 255),
				TextStrokeTransparency = 0,
				Text = " StatName:",
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = parent
			}):clone()
			statValue.Position = UDim2.new(0.5, 0, 0, 0)
			statValue.Name = "StatValue"
			statValue.Text = "123,643,231"
			statValue.TextXAlignment = Enum.TextXAlignment.Right
			statValue.Parent = parent

			addToDisplayStack(parent)
		end

		local updateTenFootStat

		local function setDisplayedStat(p)
			if changedConnection then
				changedConnection:disconnect()
				changedConnection = nil
			end

			if ancestryChangedConnection then
				ancestryChangedConnection:disconnect()
				ancestryChangedConnection = nil
			end

			v2 = p

			if v2 then
				makeTenFootInterfaceStat()
				updateTenFootStat(v2)
				ancestryChangedConnection = v2.AncestryChanged:connect(function()
					updateTenFootStat(v2, "Parent")
				end)
				changedConnection = v2.Changed:connect(function(p2)
					updateTenFootStat(v2, p2)
				end)
			end
		end

		updateTenFootStat = function(p, p2)
			if p2 and p2 == "Parent" then
				parent.StatName.Text = ""
				parent.StatValue.Text = ""
				setDisplayedStat(nil)

				tenFootInterfaceChanged()
			elseif v then
				parent.StatName.Text = " " .. tostring(p.Name) .. ":"
				parent.StatValue.Text = tostring(p.Value)
			else
				parent.StatName.Text = ""
				parent.StatValue.Text = ""
			end
		end

		local function isValidStat(instance)
			return instance:IsA("StringValue")
				or instance:IsA("IntValue")
				or instance:IsA("BoolValue")
				or instance:IsA("NumberValue")
				or instance:IsA("DoubleConstrainedValue")
				or instance:IsA("IntConstrainedValue")
		end

		local function tenFootInterfaceNewStat(p) -- 2 equivalent calls inferred from this helper
			if not v2 and isValidStat(p) then
				setDisplayedStat(p)
			end
		end

		local localPlayer = Players.LocalPlayer

		while not localPlayer do
			Players.PlayerAdded:wait()
			localPlayer = Players.LocalPlayer
		end

		function tenFootInterfaceChanged()
			local leaderstats = localPlayer:FindFirstChild("leaderstats")

			if leaderstats then
				local children = leaderstats:GetChildren()

				for i = 1, #children do
					tenFootInterfaceNewStat(children[i]) -- inferred equivalent call
				end

				if childAddedConnection then
					childAddedConnection:disconnect()
				end

				childAddedConnection = leaderstats.ChildAdded:connect(function(p)
					tenFootInterfaceNewStat(p) -- inferred equivalent call
				end)
			end
		end

		if localPlayer:FindFirstChild("leaderstats") then
			tenFootInterfaceChanged()
		else
			localPlayer.ChildAdded:connect(tenFootInterfaceChanged)
		end

		return {
			SetTopStatEnabled = function(_, p)
				v = p

				if v2 then
					updateTenFootStat(v2, "")
				end
			end
		}
	end

	return module
end

local module = CreateModule()
local TenFootInterface = {}

function TenFootInterface.IsEnabled(_)
	return tenFootInterface
end

function TenFootInterface:CreateHealthBar()
	return module:CreateHealthBar()
end

function TenFootInterface:CreateAccountType(p)
	return module:CreateAccountType(p)
end

function TenFootInterface:SetupTopStat()
	return module:SetupTopStat()
end

return TenFootInterface
