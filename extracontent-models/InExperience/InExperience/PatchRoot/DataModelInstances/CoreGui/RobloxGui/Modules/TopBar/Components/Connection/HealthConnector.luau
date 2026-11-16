local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar

local SetIsDead = require(parent.Actions.SetIsDead)
local UpdateHealth = require(parent.Actions.UpdateHealth)

local EventConnection = require(parent.Parent.Common.EventConnection)

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local extended = Roact.PureComponent:extend("HealthConnector")

extended.validateProps = t.strictInterface({ setIsDead = t.callback, updateHealth = t.callback })

function extended.init(object)
	object:setState({ character = nil, humanoid = nil })
end

function extended.didMount(object)
	local character = LocalPlayer.Character
	local humanoid

	if character then
		humanoid = character:FindFirstChildOfClass("Humanoid")
	end

	object:setState({ character = character, humanoid = humanoid })
end

function extended.render(object)
	local children = {}

	if object.state.humanoid then
		children.HealthChangedConnection = Roact.createElement(EventConnection, {
			event = object.state.humanoid.HealthChanged,
			callback = function(_)
				object.props.updateHealth(object.state.humanoid.Health, object.state.humanoid.MaxHealth)
			end
		})

		children.HumanoidDiedConnection = Roact.createElement(EventConnection, {
			event = object.state.humanoid.Died,
			callback = function()
				object.props.setIsDead(true)
			end
		})
	elseif object.state.character then
		children.ChildAddedConnection = Roact.createElement(EventConnection, {
			event = object.state.character.ChildAdded,
			callback = function(humanoid)
				if humanoid:IsA("Humanoid") then
					object:setState({ humanoid = humanoid })
				end
			end
		})
	end

	children.CharacterAddedConnection = Roact.createElement(EventConnection, {
		event = LocalPlayer.CharacterAdded,
		callback = function(instance)
			object:setState({
				humanoid = instance:FindFirstChildOfClass("Humanoid") or Roact.None,
				character = instance
			})

			object.props.setIsDead(false)
		end
	})

	children.CharacterRemovingConnection = Roact.createElement(EventConnection, {
		event = LocalPlayer.CharacterRemoving,
		callback = function()
			object:setState({ humanoid = Roact.None, character = Roact.None })
		end
	})

	return Roact.createFragment(children)
end

function extended.didUpdate(object, _, p)
	if object.state.humanoid == nil then
		object.props.updateHealth(0, 0)
	elseif object.state.humanoid ~= p.humanoid then
		object.props.setIsDead(false)
		object.props.updateHealth(object.state.humanoid.Health, object.state.humanoid.MaxHealth)
	end

	if object.state.character and object.state.character ~= p.character then
		local humanoid = object.state.character:FindFirstChildWhichIsA("Humanoid")

		if humanoid and humanoid ~= object.state.humanoid then
			object:setState({ humanoid = humanoid })
		end
	end
end

local function mapDispatchToProps(callback)
	return {
		setIsDead = function(p)
			return callback(SetIsDead(p))
		end,
		updateHealth = function(p, p2)
			return callback(UpdateHealth(p, p2))
		end
	}
end

local v

if not FFlagTopBarSignalizeHealthBar then
	return (RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended))
end

return v
