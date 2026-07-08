local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local t1 = {
	Value = false,
	ChangedEvent = Instance.new("BindableEvent")
}

local function getAnimateScript(p1) -- line: 15
	if not p1 then
		return nil
	end

	local Animate = p1:FindFirstChild("Animate")

	if Animate and Animate:IsA("LocalScript") then
		return Animate
	end

	if Animate and Animate:IsA("Script") and Animate.RunContext == Enum.RunContext.Client then
		return Animate
	end

	return nil
end
local function getPlayEmoteBindable(p2) -- line: 31
	local v26

	if not p2 then
		v26 = nil
	else
		local Animate = p2:FindFirstChild("Animate")

		v26 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	if not v26 then
		return nil
	end

	local PlayEmote = v26:FindFirstChild("PlayEmote")

	if PlayEmote and PlayEmote:IsA("BindableFunction") then
		return PlayEmote
	end

	return nil
end
local function getCanPlayEmotes(p3) -- line: 45
	local v30

	if not p3 then
		v30 = nil
	else
		local Animate = p3:FindFirstChild("Animate")

		v30 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	local v32

	if not v30 then
		v32 = nil
	else
		local PlayEmote = v30:FindFirstChild("PlayEmote")

		v32 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
	end

	return v32 ~= nil
end

local u7 = nil
local u8 = nil
local u9 = nil

local function disconnectListeners() -- line: 52
	-- upvalues: u7 (ref), u8 (ref), u9 (ref)
	if u7 then
		u7:Disconnect()
		u7 = nil
	end

	if u8 then
		u8:Disconnect()
		u8 = nil
	end

	if u9 then
		u9:Disconnect()
		u9 = nil
	end
end

local u11 = nil

local function checkUpdate(p4) -- line: 71
	-- upvalues: t1 (copy), u11 (ref)
	local v35

	if not p4 then
		v35 = nil
	else
		local Animate = p4:FindFirstChild("Animate")

		v35 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	local v37

	if not v35 then
		v37 = nil
	else
		local PlayEmote = v35:FindFirstChild("PlayEmote")

		v37 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
	end

	local v39 = v37 ~= nil

	if v39 ~= t1.Value then
		t1.Value = v39
		t1.ChangedEvent:Fire(v39)
	end

	u11(v39, p4)
end
local function connectAnimateAddedListener(p5) -- line: 82
	-- upvalues: t1 (copy), u11 (ref), u7 (ref)
	local v41

	if not p5 then
		v41 = nil
	else
		local Animate = p5:FindFirstChild("Animate")

		v41 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	if v41 then
		local v43

		if not p5 then
			v43 = nil
		else
			local Animate = p5:FindFirstChild("Animate")

			v43 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
		end

		local v45

		if not v43 then
			v45 = nil
		else
			local PlayEmote = v43:FindFirstChild("PlayEmote")

			v45 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
		end

		local v47 = v45 ~= nil

		if v47 ~= t1.Value then
			t1.Value = v47
			t1.ChangedEvent:Fire(v47)
		end

		u11(v47, p5)

		return
	end

	u7 = p5.ChildAdded:Connect(function(child) -- line: 89
		-- upvalues: p5 (copy), t1 (copy), u11 (ref)
		if (child:IsA("LocalScript") or child:IsA("Script") and child.RunContext == Enum.RunContext.Client) and child.Name == "Animate" then
			local v113 = p5
			local v114

			if not v113 then
				v114 = nil
			else
				local Animate = v113:FindFirstChild("Animate")

				v114 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
			end

			local v116

			if not v114 then
				v116 = nil
			else
				local PlayEmote = v114:FindFirstChild("PlayEmote")

				v116 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
			end

			local v118 = v116 ~= nil

			if v118 ~= t1.Value then
				t1.Value = v118
				t1.ChangedEvent:Fire(v118)
			end

			u11(v118, v113)
		end
	end)
end
local function connectPlayEmoteAddedListener(p6, p7) -- line: 98
	-- upvalues: t1 (copy), u11 (ref), u8 (ref)
	local v50

	if not p6 then
		v50 = nil
	else
		local Animate = p6:FindFirstChild("Animate")

		v50 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	local v52

	if not v50 then
		v52 = nil
	else
		local PlayEmote = v50:FindFirstChild("PlayEmote")

		v52 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
	end

	if v52 then
		local v54

		if not p6 then
			v54 = nil
		else
			local Animate = p6:FindFirstChild("Animate")

			v54 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
		end

		local v56

		if not v54 then
			v56 = nil
		else
			local PlayEmote = v54:FindFirstChild("PlayEmote")

			v56 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
		end

		local v58 = v56 ~= nil

		if v58 ~= t1.Value then
			t1.Value = v58
			t1.ChangedEvent:Fire(v58)
		end

		u11(v58, p6)

		return
	end

	u8 = p7.ChildAdded:Connect(function(child) -- line: 105
		-- upvalues: p6 (copy), t1 (copy), u11 (ref)
		if child:IsA("BindableFunction") and child.Name == "PlayEmote" then
			local v120 = p6
			local v121

			if not v120 then
				v121 = nil
			else
				local Animate = v120:FindFirstChild("Animate")

				v121 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
			end

			local v123

			if not v121 then
				v123 = nil
			else
				local PlayEmote = v121:FindFirstChild("PlayEmote")

				v123 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
			end

			local v125 = v123 ~= nil

			if v125 ~= t1.Value then
				t1.Value = v125
				t1.ChangedEvent:Fire(v125)
			end

			u11(v125, v120)
		end
	end)
end
local function connectPlayEmoteRemovedListener(p8) -- line: 112
	-- upvalues: t1 (copy), u11 (ref), u9 (ref)
	local v60

	if not p8 then
		v60 = nil
	else
		local Animate = p8:FindFirstChild("Animate")

		v60 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	local v62

	if not v60 then
		v62 = nil
	else
		local PlayEmote = v60:FindFirstChild("PlayEmote")

		v62 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
	end

	local v64 = v62

	if not v64 then
		local v65

		if not p8 then
			v65 = nil
		else
			local Animate = p8:FindFirstChild("Animate")

			v65 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
		end

		local v67

		if not v65 then
			v67 = nil
		else
			local PlayEmote = v65:FindFirstChild("PlayEmote")

			v67 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
		end

		local v69 = v67 ~= nil

		if v69 ~= t1.Value then
			t1.Value = v69
			t1.ChangedEvent:Fire(v69)
		end

		u11(v69, p8)

		return
	end

	u9 = v64.AncestryChanged:Connect(function(_, parent) -- line: 119
		-- upvalues: v64 (copy), p8 (copy), t1 (copy), u11 (ref)
		if not parent or not v64:IsDescendantOf(p8) then
			local v128 = p8
			local v129

			if not v128 then
				v129 = nil
			else
				local Animate = v128:FindFirstChild("Animate")

				v129 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
			end

			local v131

			if not v129 then
				v131 = nil
			else
				local PlayEmote = v129:FindFirstChild("PlayEmote")

				v131 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
			end

			local v133 = v131 ~= nil

			if v133 ~= t1.Value then
				t1.Value = v133
				t1.ChangedEvent:Fire(v133)
			end

			u11(v133, v128)
		end
	end)
end

function u11(p10, p11) -- line: 126
	-- upvalues: u7 (ref), u8 (ref), u9 (ref), t1 (copy), u11 (ref)
	if u7 then
		u7:Disconnect()
		u7 = nil
	end

	if u8 then
		u8:Disconnect()
		u8 = nil
	end

	if u9 then
		u9:Disconnect()
		u9 = nil
	end

	if not p11 then
		return
	end

	if p10 then
		local v72

		if not p11 then
			v72 = nil
		else
			local Animate = p11:FindFirstChild("Animate")

			v72 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
		end

		local v74

		if not v72 then
			v74 = nil
		else
			local PlayEmote = v72:FindFirstChild("PlayEmote")

			v74 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
		end

		local v76 = v74

		if not v76 then
			local v77

			if not p11 then
				v77 = nil
			else
				local Animate = p11:FindFirstChild("Animate")

				v77 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
			end

			local v79

			if not v77 then
				v79 = nil
			else
				local PlayEmote = v77:FindFirstChild("PlayEmote")

				v79 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
			end

			local v81 = v79 ~= nil

			if v81 ~= t1.Value then
				t1.Value = v81
				t1.ChangedEvent:Fire(v81)
			end

			u11(v81, p11)

			return
		end

		u9 = v76.AncestryChanged:Connect(function(_, parent) -- line: 119
			-- upvalues: v76 (copy), p11 (copy), t1 (copy), u11 (ref)
			if not parent or not v76:IsDescendantOf(p11) then
				local v136 = p11
				local v137

				if not v136 then
					v137 = nil
				else
					local Animate = v136:FindFirstChild("Animate")

					v137 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
				end

				local v139

				if not v137 then
					v139 = nil
				else
					local PlayEmote = v137:FindFirstChild("PlayEmote")

					v139 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
				end

				local v141 = v139 ~= nil

				if v141 ~= t1.Value then
					t1.Value = v141
					t1.ChangedEvent:Fire(v141)
				end

				u11(v141, v136)
			end
		end)

		return
	end

	local v82

	if not p11 then
		v82 = nil
	else
		local Animate = p11:FindFirstChild("Animate")

		v82 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	if v82 then
		local v84

		if not p11 then
			v84 = nil
		else
			local Animate = p11:FindFirstChild("Animate")

			v84 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
		end

		local v86

		if not v84 then
			v86 = nil
		else
			local PlayEmote = v84:FindFirstChild("PlayEmote")

			v86 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
		end

		if v86 then
			local v88

			if not p11 then
				v88 = nil
			else
				local Animate = p11:FindFirstChild("Animate")

				v88 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
			end

			local v90

			if not v88 then
				v90 = nil
			else
				local PlayEmote = v88:FindFirstChild("PlayEmote")

				v90 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
			end

			local v92 = v90 ~= nil

			if v92 ~= t1.Value then
				t1.Value = v92
				t1.ChangedEvent:Fire(v92)
			end

			u11(v92, p11)

			return
		end

		u8 = v82.ChildAdded:Connect(function(child) -- line: 105
			-- upvalues: p11 (copy), t1 (copy), u11 (ref)
			if child:IsA("BindableFunction") and child.Name == "PlayEmote" then
				local v143 = p11
				local v144

				if not v143 then
					v144 = nil
				else
					local Animate = v143:FindFirstChild("Animate")

					v144 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
				end

				local v146

				if not v144 then
					v146 = nil
				else
					local PlayEmote = v144:FindFirstChild("PlayEmote")

					v146 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
				end

				local v148 = v146 ~= nil

				if v148 ~= t1.Value then
					t1.Value = v148
					t1.ChangedEvent:Fire(v148)
				end

				u11(v148, v143)
			end
		end)

		return
	end

	local v93

	if not p11 then
		v93 = nil
	else
		local Animate = p11:FindFirstChild("Animate")

		v93 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	if v93 then
		local v95

		if not p11 then
			v95 = nil
		else
			local Animate = p11:FindFirstChild("Animate")

			v95 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
		end

		local v97

		if not v95 then
			v97 = nil
		else
			local PlayEmote = v95:FindFirstChild("PlayEmote")

			v97 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
		end

		local v99 = v97 ~= nil

		if v99 ~= t1.Value then
			t1.Value = v99
			t1.ChangedEvent:Fire(v99)
		end

		u11(v99, p11)

		return
	end

	u7 = p11.ChildAdded:Connect(function(child) -- line: 89
		-- upvalues: p11 (copy), t1 (copy), u11 (ref)
		if (child:IsA("LocalScript") or child:IsA("Script") and child.RunContext == Enum.RunContext.Client) and child.Name == "Animate" then
			local v150 = p11
			local v151

			if not v150 then
				v151 = nil
			else
				local Animate = v150:FindFirstChild("Animate")

				v151 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
			end

			local v153

			if not v151 then
				v153 = nil
			else
				local PlayEmote = v151:FindFirstChild("PlayEmote")

				v153 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
			end

			local v155 = v153 ~= nil

			if v155 ~= t1.Value then
				t1.Value = v155
				t1.ChangedEvent:Fire(v155)
			end

			u11(v155, v150)
		end
	end)
end

local function onCharacterChanged(p13) -- line: 146
	-- upvalues: u7 (ref), u8 (ref), u9 (ref), t1 (copy), u11 (ref)
	if u7 then
		u7:Disconnect()
		u7 = nil
	end

	if u8 then
		u8:Disconnect()
		u8 = nil
	end

	if u9 then
		u9:Disconnect()
		u9 = nil
	end

	local v101

	if not p13 then
		v101 = nil
	else
		local Animate = p13:FindFirstChild("Animate")

		v101 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	local v103

	if not v101 then
		v103 = nil
	else
		local PlayEmote = v101:FindFirstChild("PlayEmote")

		v103 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
	end

	local v105 = v103 ~= nil

	if v105 ~= t1.Value then
		t1.Value = v105
		t1.ChangedEvent:Fire(v105)
	end

	u11(v105, p13)
end

LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function() -- line: 151
	-- upvalues: LocalPlayer (ref), u7 (ref), u8 (ref), u9 (ref), t1 (copy), u11 (ref)
	local Character = LocalPlayer.Character

	if u7 then
		u7:Disconnect()
		u7 = nil
	end

	if u8 then
		u8:Disconnect()
		u8 = nil
	end

	if u9 then
		u9:Disconnect()
		u9 = nil
	end

	local v107

	if not Character then
		v107 = nil
	else
		local Animate = Character:FindFirstChild("Animate")

		v107 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
	end

	local v109

	if not v107 then
		v109 = nil
	else
		local PlayEmote = v107:FindFirstChild("PlayEmote")

		v109 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
	end

	local v111 = v109 ~= nil

	if v111 ~= t1.Value then
		t1.Value = v111
		t1.ChangedEvent:Fire(v111)
	end

	u11(v111, Character)
end)

local Character = LocalPlayer.Character

if u7 then
	u7:Disconnect()
	u7 = nil
end

if u8 then
	u8:Disconnect()
	u8 = nil
end

if u9 then
	u9:Disconnect()
	u9 = nil
end

local v18

if not Character then
	v18 = nil
else
	local Animate = Character:FindFirstChild("Animate")

	v18 = if not Animate or not Animate:IsA("LocalScript") then if not Animate or (not Animate:IsA("Script") or Animate.RunContext ~= Enum.RunContext.Client) then nil else Animate else Animate
end

local v20

if not v18 then
	v20 = nil
else
	local PlayEmote = v18:FindFirstChild("PlayEmote")

	v20 = if not PlayEmote or not PlayEmote:IsA("BindableFunction") then nil else PlayEmote
end

local v22 = v20 ~= nil

if v22 ~= t1.Value then
	t1.Value = v22
	t1.ChangedEvent:Fire(v22)
end

u11(v22, Character)

return t1
