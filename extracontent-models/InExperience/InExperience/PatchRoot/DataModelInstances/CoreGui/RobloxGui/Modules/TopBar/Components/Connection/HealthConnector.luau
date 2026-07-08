local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent
local FFlagTopBarSignalizeHealthBar = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeHealthBar
local SetIsDead = require(ParentParent.Actions.SetIsDead)
local UpdateHealth = require(ParentParent.Actions.UpdateHealth)
local EventConnection = require(ParentParent.Parent.Common.EventConnection)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local v12 = Roact.PureComponent:extend("HealthConnector")

v12.validateProps = t.strictInterface({
	setIsDead = t.callback,
	updateHealth = t.callback
})

function v12.init(p1) -- line: 34
	p1:setState({
		character = nil,
		humanoid = nil
	})
end
function v12.didMount(p2) -- line: 41
	-- upvalues: LocalPlayer (ref)
	local Character = LocalPlayer.Character
	local Humanoid = nil

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	end

	p2:setState({
		character = Character,
		humanoid = Humanoid
	})
end
function v12.render(p3) -- line: 54
	-- upvalues: Roact (copy), EventConnection (copy), LocalPlayer (ref)
	local t1 = {}

	if p3.state.humanoid then
		t1.HealthChangedConnection = Roact.createElement(EventConnection, {
			event = p3.state.humanoid.HealthChanged,
			callback = function(_) -- line: 60
				-- upvalues: p3 (copy)
				p3.props.updateHealth(p3.state.humanoid.Health, p3.state.humanoid.MaxHealth)
			end
		})
		t1.HumanoidDiedConnection = Roact.createElement(EventConnection, {
			event = p3.state.humanoid.Died,
			callback = function() -- line: 67
				-- upvalues: p3 (copy)
				p3.props.setIsDead(true)
			end
		})
	elseif p3.state.character then
		t1.ChildAddedConnection = Roact.createElement(EventConnection, {
			event = p3.state.character.ChildAdded,
			callback = function(p5) -- line: 74
				-- upvalues: p3 (copy)
				if p5:IsA("Humanoid") then
					p3:setState({
						humanoid = p5
					})
				end
			end
		})
	end

	t1.CharacterAddedConnection = Roact.createElement(EventConnection, {
		event = LocalPlayer.CharacterAdded,
		callback = function(p6) -- line: 86
			-- upvalues: p3 (copy), Roact (copy)
			p3:setState({
				humanoid = p6:FindFirstChildOfClass("Humanoid") or Roact.None,
				character = p6
			})
			p3.props.setIsDead(false)
		end
	})
	t1.CharacterRemovingConnection = Roact.createElement(EventConnection, {
		event = LocalPlayer.CharacterRemoving,
		callback = function() -- line: 97
			-- upvalues: p3 (copy), Roact (copy)
			p3:setState({
				humanoid = Roact.None,
				character = Roact.None
			})
		end
	})

	return Roact.createFragment(t1)
end
function v12.didUpdate(p7, _, p9) -- line: 108
	if p7.state.humanoid == nil then
		p7.props.updateHealth(0, 0)
	elseif p7.state.humanoid ~= p9.humanoid then
		p7.props.setIsDead(false)
		p7.props.updateHealth(p7.state.humanoid.Health, p7.state.humanoid.MaxHealth)
	end

	if p7.state.character and p7.state.character ~= p9.character then
		local Humanoid = p7.state.character:FindFirstChildWhichIsA("Humanoid")

		if Humanoid and Humanoid ~= p7.state.humanoid then
			p7:setState({
				humanoid = Humanoid
			})
		end
	end
end

local function mapDispatchToProps(p10) -- line: 126
	-- upvalues: SetIsDead (copy), UpdateHealth (copy)
	return {
		setIsDead = function(p11) -- line: 128
			-- upvalues: p10 (copy), SetIsDead (copy)
			return p10(SetIsDead(p11))
		end,
		updateHealth = function(p12, p13) -- line: 132
			-- upvalues: p10 (copy), UpdateHealth (copy)
			return p10(UpdateHealth(p12, p13))
		end
	}
end

return if not FFlagTopBarSignalizeHealthBar then RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v12) else nil
