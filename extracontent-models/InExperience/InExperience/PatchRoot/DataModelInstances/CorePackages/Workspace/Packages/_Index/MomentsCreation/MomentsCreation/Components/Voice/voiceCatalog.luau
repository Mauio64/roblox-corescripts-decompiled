local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

local GetFIntMomentsTTSDefaultVoiceId = require(MomentsCreation.Flags.GetFIntMomentsTTSDefaultVoiceId)

local v = {
	{ id = 9, name = "Retro voice #1", language = "English", gender = "male" },
	{ id = 10, name = "Retro voice #2", language = "English", gender = "male" },
	{ id = 1, name = "British male", language = "English (UK)", gender = "male" },
	{ id = 2, name = "British female", language = "English (UK)", gender = "female" },
	{ id = 3, name = "United States male #1", language = "English (US)", gender = "male" },
	{ id = 4, name = "United States female #1", language = "English (US)", gender = "female" },
	{ id = 5, name = "United States male #2", language = "English (US)", gender = "male" },
	{ id = 6, name = "United States female #2", language = "English (US)", gender = "female" },
	{ id = 7, name = "Australian male", language = "English (AU)", gender = "male" },
	{ id = 8, name = "Australian female", language = "English (AU)", gender = "female" },
	{ id = 11, name = "Host voice", language = "English", gender = "female" },
	{ id = 101, name = "Spanish male", language = "Spanish", gender = "male" },
	{ id = 102, name = "Spanish female", language = "Spanish", gender = "female" },
	{ id = 201, name = "German male", language = "German", gender = "male" },
	{ id = 202, name = "German female", language = "German", gender = "female" },
	{ id = 301, name = "Italian male", language = "Italian", gender = "male" },
	{ id = 302, name = "Italian female", language = "Italian", gender = "female" },
	{ id = 401, name = "French male", language = "French", gender = "male" },
	{ id = 402, name = "French female", language = "French", gender = "female" }
}

local v2 = {}

for _, v3 in v do
	v2[v3.id] = v3
end

local VoiceCatalog = {}

function VoiceCatalog.getDefaultVoiceId()
	return GetFIntMomentsTTSDefaultVoiceId()
end

function VoiceCatalog.getVoiceById(p: number)
	return v2[p]
end

function VoiceCatalog.getOrderedVoices()
	local defaultVoiceId = VoiceCatalog.getDefaultVoiceId()
	local orderedVoices = {}
	local v3 = v2[defaultVoiceId]

	if v3 ~= nil then
		table.insert(orderedVoices, v3)
	end

	for _, v4 in v do
		if v4.id ~= defaultVoiceId then
			table.insert(orderedVoices, v4)
		end
	end

	return orderedVoices
end

return VoiceCatalog
