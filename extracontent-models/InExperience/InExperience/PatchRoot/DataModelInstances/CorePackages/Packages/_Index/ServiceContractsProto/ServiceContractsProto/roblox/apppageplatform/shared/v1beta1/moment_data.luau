local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 258
	-- upvalues: t2 (copy)
	return (setmetatable({
		moment_id = if t3 ~= nil and t3.moment_id ~= nil then t3.moment_id else nil,
		asset_id = if t3 ~= nil and t3.asset_id ~= nil then t3.asset_id else nil,
		creator_id = if t3 ~= nil and t3.creator_id ~= nil then t3.creator_id else nil,
		status = if t3 ~= nil and t3.status ~= nil then t3.status else nil,
		metadata = if t3 ~= nil and t3.metadata ~= nil then t3.metadata else nil
	}, t2))
end
function t2.encode(p1) -- line: 268
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.moment_id ~= nil then
		local v15, v16 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.moment_id)
	end

	if p1.asset_id ~= nil then
		local v17, v18 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.asset_id)
	end

	if p1.creator_id ~= nil then
		local v19, v20 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v19, v20, p1.creator_id)
	end

	if p1.status ~= nil then
		local v21, v22 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v21, v22, p1.status)
	end

	if p1.metadata ~= nil then
		local v23 = p1.metadata:encode()
		local v24, v25 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v24, v25, v23, buffer.len(v23))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 303
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v28 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v30, v31

		v30, v31, n2 = proto.readTag(p2, n2)

		if v31 == proto.wireTypes.varint then
			local v32

			v32, n2 = proto.readVarInt(p2, n2)
		elseif v31 == proto.wireTypes.lengthDelimited then
			if v30 == 1 then
				local v33

				v33, n2 = proto.readBuffer(p2, n2)
				v28.moment_id = buffer.tostring(v33)
			elseif v30 == 2 then
				local v34

				v34, n2 = proto.readBuffer(p2, n2)
				v28.asset_id = buffer.tostring(v34)
			elseif v30 == 3 then
				local v35

				v35, n2 = proto.readBuffer(p2, n2)
				v28.creator_id = buffer.tostring(v35)
			elseif v30 == 4 then
				local v36

				v36, n2 = proto.readBuffer(p2, n2)
				v28.status = buffer.tostring(v36)
			elseif v30 == 5 then
				local v37

				v37, n2 = proto.readBuffer(p2, n2)
				v28.metadata = t1.MomentData_MomentMetadata.decode(v37)
			else
				local v38, v39 = proto.readVarInt(p2, n2)

				n2 = v39 + v38
			end
		elseif v31 == proto.wireTypes.i32 then
			local v40

			v40, n2 = proto.readFixed32(p2, n2)
		elseif v31 == proto.wireTypes.i64 then
			local v41

			v41, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v31)
		end
	end

	return v28
end
function t2.jsonEncode(p3) -- line: 366
	local t4 = {}

	if p3.moment_id ~= nil then
		t4.momentId = p3.moment_id
	end

	if p3.asset_id ~= nil then
		t4.assetId = p3.asset_id
	end

	if p3.creator_id ~= nil then
		t4.creatorId = p3.creator_id
	end

	if p3.status ~= nil then
		t4.status = p3.status
	end

	if p3.metadata ~= nil then
		t4.metadata = p3.metadata:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 392
	-- upvalues: t2 (copy), t1 (copy)
	local v45 = t2.new()

	if t5.moment_id ~= nil then
		v45.moment_id = t5.moment_id
	end

	if t5.momentId ~= nil then
		v45.moment_id = t5.momentId
	end

	if t5.asset_id ~= nil then
		v45.asset_id = t5.asset_id
	end

	if t5.assetId ~= nil then
		v45.asset_id = t5.assetId
	end

	if t5.creator_id ~= nil then
		v45.creator_id = t5.creator_id
	end

	if t5.creatorId ~= nil then
		v45.creator_id = t5.creatorId
	end

	if t5.status ~= nil then
		v45.status = t5.status
	end

	if t5.metadata ~= nil then
		v45.metadata = t1.MomentData_MomentMetadata.jsonDecode(t5.metadata)
	end

	return v45
end

t2.descriptor = {
	name = "MomentData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentData"
}
t1.MomentData = t2
typeRegistry.default:register(t1.MomentData)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 444
	-- upvalues: t6 (copy)
	return (setmetatable({
		asset_total_duration_seconds = if t7 ~= nil and t7.asset_total_duration_seconds ~= nil then t7.asset_total_duration_seconds else nil,
		capture_type = if t7 ~= nil and t7.capture_type ~= nil then t7.capture_type else nil,
		description = if t7 ~= nil and t7.description ~= nil then t7.description else nil,
		capture_universe_id = if t7 ~= nil and t7.capture_universe_id ~= nil then t7.capture_universe_id else nil,
		capture_place_id = if t7 ~= nil and t7.capture_place_id ~= nil then t7.capture_place_id else nil,
		edits = if t7 ~= nil and t7.edits ~= nil then t7.edits else nil
	}, t6))
end
function t6.encode(p4) -- line: 461
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.asset_total_duration_seconds ~= nil then
		local v50, v51 = proto.writeTag(buf, n3, 1, proto.wireTypes.i32)

		buf, n3 = proto.writeFloat(v50, v51, p4.asset_total_duration_seconds)
	end

	if p4.capture_type ~= nil then
		local v52, v53 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v52, v53, p4.capture_type)
	end

	if p4.description ~= nil then
		local v54, v55 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v54, v55, p4.description)
	end

	if p4.capture_universe_id ~= nil then
		local v56, v57 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v56, v57, p4.capture_universe_id)
	end

	if p4.capture_place_id ~= nil then
		local v58, v59 = proto.writeTag(buf, n3, 5, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v58, v59, p4.capture_place_id)
	end

	if p4.edits ~= nil then
		local v60 = p4.edits:encode()
		local v61, v62 = proto.writeTag(buf, n3, 6, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v61, v62, v60, buffer.len(v60))
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 501
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v65 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v67, v68

		v67, v68, n4 = proto.readTag(p5, n4)

		if v68 == proto.wireTypes.varint then
			local v69

			v69, n4 = proto.readVarInt(p5, n4)
		elseif v68 == proto.wireTypes.lengthDelimited then
			if v67 == 2 then
				local v70

				v70, n4 = proto.readBuffer(p5, n4)
				v65.capture_type = buffer.tostring(v70)
			elseif v67 == 3 then
				local v71

				v71, n4 = proto.readBuffer(p5, n4)
				v65.description = buffer.tostring(v71)
			elseif v67 == 4 then
				local v72

				v72, n4 = proto.readBuffer(p5, n4)
				v65.capture_universe_id = buffer.tostring(v72)
			elseif v67 == 5 then
				local v73

				v73, n4 = proto.readBuffer(p5, n4)
				v65.capture_place_id = buffer.tostring(v73)
			elseif v67 == 6 then
				local v74

				v74, n4 = proto.readBuffer(p5, n4)
				v65.edits = t1.MomentData_MomentMetadata_MomentEdits.decode(v74)
			else
				local v75, v76 = proto.readVarInt(p5, n4)

				n4 = v76 + v75
			end
		elseif v68 == proto.wireTypes.i32 then
			if v67 == 1 then
				local v77

				v77, n4 = proto.readFloat(p5, n4)
				v65.asset_total_duration_seconds = v77
			else
				local v78

				v78, n4 = proto.readFixed32(p5, n4)
			end
		elseif v68 == proto.wireTypes.i64 then
			local v79

			v79, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v68)
		end
	end

	return v65
end
function t6.jsonEncode(p6) -- line: 569
	-- upvalues: proto (copy)
	local t8 = {}

	if p6.asset_total_duration_seconds ~= nil then
		t8.assetTotalDurationSeconds = proto.json.serializeNumber(p6.asset_total_duration_seconds)
	end

	if p6.capture_type ~= nil then
		t8.captureType = p6.capture_type
	end

	if p6.description ~= nil then
		t8.description = p6.description
	end

	if p6.capture_universe_id ~= nil then
		t8.captureUniverseId = p6.capture_universe_id
	end

	if p6.capture_place_id ~= nil then
		t8.capturePlaceId = p6.capture_place_id
	end

	if p6.edits ~= nil then
		t8.edits = p6.edits:jsonEncode()
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 599
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v83 = t6.new()

	if t9.asset_total_duration_seconds ~= nil then
		v83.asset_total_duration_seconds = proto.json.deserializeNumber(t9.asset_total_duration_seconds)
	end

	if t9.assetTotalDurationSeconds ~= nil then
		v83.asset_total_duration_seconds = proto.json.deserializeNumber(t9.assetTotalDurationSeconds)
	end

	if t9.capture_type ~= nil then
		v83.capture_type = t9.capture_type
	end

	if t9.captureType ~= nil then
		v83.capture_type = t9.captureType
	end

	if t9.description ~= nil then
		v83.description = t9.description
	end

	if t9.capture_universe_id ~= nil then
		v83.capture_universe_id = t9.capture_universe_id
	end

	if t9.captureUniverseId ~= nil then
		v83.capture_universe_id = t9.captureUniverseId
	end

	if t9.capture_place_id ~= nil then
		v83.capture_place_id = t9.capture_place_id
	end

	if t9.capturePlaceId ~= nil then
		v83.capture_place_id = t9.capturePlaceId
	end

	if t9.edits ~= nil then
		v83.edits = t1.MomentData_MomentMetadata_MomentEdits.jsonDecode(t9.edits)
	end

	return v83
end

t6.descriptor = {
	name = "MomentData_MomentMetadata",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentMetadata"
}
t1.MomentData_MomentMetadata = t6
typeRegistry.default:register(t1.MomentData_MomentMetadata)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 659
	-- upvalues: t10 (copy)
	return (setmetatable({
		music = if t11 ~= nil and t11.music ~= nil then t11.music else nil,
		trim = if t11 ~= nil and t11.trim ~= nil then t11.trim else nil,
		text_overlays = if t11 ~= nil and t11.text_overlays ~= nil then t11.text_overlays else {}
	}, t10))
end
function t10.encode(p7) -- line: 669
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.music ~= nil then
		local v88 = p7.music:encode()
		local v89, v90 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v89, v90, v88, buffer.len(v88))
	end

	if p7.trim ~= nil then
		local v91 = p7.trim:encode()
		local v92, v93 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v92, v93, v91, buffer.len(v91))
	end

	if p7.text_overlays ~= nil and #p7.text_overlays > 0 then
		for _, v95 in p7.text_overlays do
			local v96 = v95:encode()
			local v97, v98 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v97, v98, v96, buffer.len(v96))
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 698
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v101 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v103, v104

		v103, v104, n6 = proto.readTag(p8, n6)

		if v104 == proto.wireTypes.varint then
			local v105

			v105, n6 = proto.readVarInt(p8, n6)
		elseif v104 == proto.wireTypes.lengthDelimited then
			if v103 == 1 then
				local v106

				v106, n6 = proto.readBuffer(p8, n6)
				v101.music = t1.MomentData_MomentMetadata_MomentEdits_MusicEdit.decode(v106)
			elseif v103 == 2 then
				local v107

				v107, n6 = proto.readBuffer(p8, n6)
				v101.trim = t1.MomentData_MomentMetadata_MomentEdits_TrimEdit.decode(v107)
			elseif v103 == 3 then
				local v108

				v108, n6 = proto.readBuffer(p8, n6)
				table.insert(v101.text_overlays, t1.MomentData_MomentMetadata_MomentEdits_TextOverlay.decode(v108))
			else
				local v109, v110 = proto.readVarInt(p8, n6)

				n6 = v110 + v109
			end
		elseif v104 == proto.wireTypes.i32 then
			local v111

			v111, n6 = proto.readFixed32(p8, n6)
		elseif v104 == proto.wireTypes.i64 then
			local v112

			v112, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v104)
		end
	end

	return v101
end
function t10.jsonEncode(p9) -- line: 754
	local t12 = {}

	if p9.music ~= nil then
		t12.music = p9.music:jsonEncode()
	end

	if p9.trim ~= nil then
		t12.trim = p9.trim:jsonEncode()
	end

	if p9.text_overlays ~= nil and #p9.text_overlays > 0 then
		local t13 = {}

		for _, v117 in p9.text_overlays do
			table.insert(t13, v117:jsonEncode())
		end

		t12.textOverlays = t13
	end

	return t12
end
function t10.jsonDecode(t14: {[any]: any}) -- line: 776
	-- upvalues: t10 (copy), t1 (copy)
	local v119 = t10.new()

	if t14.music ~= nil then
		v119.music = t1.MomentData_MomentMetadata_MomentEdits_MusicEdit.jsonDecode(t14.music)
	end

	if t14.trim ~= nil then
		v119.trim = t1.MomentData_MomentMetadata_MomentEdits_TrimEdit.jsonDecode(t14.trim)
	end

	if t14.text_overlays ~= nil then
		local t15 = {}

		for _, v122 in t14.text_overlays do
			table.insert(t15, t1.MomentData_MomentMetadata_MomentEdits_TextOverlay.jsonDecode(v122))
		end

		v119.text_overlays = t15
	end

	if t14.textOverlays ~= nil then
		local t16 = {}

		for _, v125 in t14.textOverlays do
			table.insert(t16, t1.MomentData_MomentMetadata_MomentEdits_TextOverlay.jsonDecode(v125))
		end

		v119.text_overlays = t16
	end

	return v119
end

t10.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentEdits"
}
t1.MomentData_MomentMetadata_MomentEdits = t10
typeRegistry.default:register(t1.MomentData_MomentMetadata_MomentEdits)

local t17 = {}

t17.__index = t17

function t17.new(t18: {[any]: any}?) -- line: 824
	-- upvalues: t17 (copy)
	return (setmetatable({
		asset_id = if t18 ~= nil and t18.asset_id ~= nil then t18.asset_id else nil,
		start_time_seconds = if t18 ~= nil and t18.start_time_seconds ~= nil then t18.start_time_seconds else nil
	}, t17))
end
function t17.encode(p10) -- line: 833
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.asset_id ~= nil then
		local v130, v131 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v130, v131, p10.asset_id)
	end

	if p10.start_time_seconds ~= nil then
		local v132, v133 = proto.writeTag(buf, n7, 2, proto.wireTypes.i32)

		buf, n7 = proto.writeFloat(v132, v133, p10.start_time_seconds)
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t17.decode(p11: buffer) -- line: 854
	-- upvalues: t17 (copy), proto (copy)
	local v136 = t17.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v138, v139

		v138, v139, n8 = proto.readTag(p11, n8)

		if v139 == proto.wireTypes.varint then
			local v140

			v140, n8 = proto.readVarInt(p11, n8)
		elseif v139 == proto.wireTypes.lengthDelimited then
			if v138 == 1 then
				local v141

				v141, n8 = proto.readBuffer(p11, n8)
				v136.asset_id = buffer.tostring(v141)
			else
				local v142, v143 = proto.readVarInt(p11, n8)

				n8 = v143 + v142
			end
		elseif v139 == proto.wireTypes.i32 then
			if v138 == 2 then
				local v144

				v144, n8 = proto.readFloat(p11, n8)
				v136.start_time_seconds = v144
			else
				local v145

				v145, n8 = proto.readFixed32(p11, n8)
			end
		elseif v139 == proto.wireTypes.i64 then
			local v146

			v146, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v139)
		end
	end

	return v136
end
function t17.jsonEncode(p12) -- line: 904
	-- upvalues: proto (copy)
	local t19 = {}

	if p12.asset_id ~= nil then
		t19.assetId = p12.asset_id
	end

	if p12.start_time_seconds ~= nil then
		t19.startTimeSeconds = proto.json.serializeNumber(p12.start_time_seconds)
	end

	return t19
end
function t17.jsonDecode(t20: {[any]: any}) -- line: 920
	-- upvalues: t17 (copy), proto (copy)
	local v150 = t17.new()

	if t20.asset_id ~= nil then
		v150.asset_id = t20.asset_id
	end

	if t20.assetId ~= nil then
		v150.asset_id = t20.assetId
	end

	if t20.start_time_seconds ~= nil then
		v150.start_time_seconds = proto.json.deserializeNumber(t20.start_time_seconds)
	end

	if t20.startTimeSeconds ~= nil then
		v150.start_time_seconds = proto.json.deserializeNumber(t20.startTimeSeconds)
	end

	return v150
end

t17.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_MusicEdit",
	fullName = "roblox.apppageplatform.shared.v1beta1.MusicEdit"
}
t1.MomentData_MomentMetadata_MomentEdits_MusicEdit = t17
typeRegistry.default:register(t1.MomentData_MomentMetadata_MomentEdits_MusicEdit)

local t21 = {}

t21.__index = t21

function t21.new(t22: {[any]: any}?) -- line: 959
	-- upvalues: t21 (copy)
	return (setmetatable({
		start_time_seconds = if t22 ~= nil and t22.start_time_seconds ~= nil then t22.start_time_seconds else nil,
		end_time_seconds = if t22 ~= nil and t22.end_time_seconds ~= nil then t22.end_time_seconds else nil
	}, t21))
end
function t21.encode(p13) -- line: 968
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.start_time_seconds ~= nil then
		local v155, v156 = proto.writeTag(buf, n9, 1, proto.wireTypes.i32)

		buf, n9 = proto.writeFloat(v155, v156, p13.start_time_seconds)
	end

	if p13.end_time_seconds ~= nil then
		local v157, v158 = proto.writeTag(buf, n9, 2, proto.wireTypes.i32)

		buf, n9 = proto.writeFloat(v157, v158, p13.end_time_seconds)
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t21.decode(p14: buffer) -- line: 989
	-- upvalues: t21 (copy), proto (copy)
	local v161 = t21.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v163, v164

		v163, v164, n10 = proto.readTag(p14, n10)

		if v164 == proto.wireTypes.varint then
			local v165

			v165, n10 = proto.readVarInt(p14, n10)
		elseif v164 == proto.wireTypes.lengthDelimited then
			local v166, v167 = proto.readVarInt(p14, n10)

			n10 = v167 + v166
		elseif v164 == proto.wireTypes.i32 then
			if v163 == 1 then
				local v168

				v168, n10 = proto.readFloat(p14, n10)
				v161.start_time_seconds = v168
			elseif v163 == 2 then
				local v169

				v169, n10 = proto.readFloat(p14, n10)
				v161.end_time_seconds = v169
			else
				local v170

				v170, n10 = proto.readFixed32(p14, n10)
			end
		elseif v164 == proto.wireTypes.i64 then
			local v171

			v171, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v164)
		end
	end

	return v161
end
function t21.jsonEncode(p15) -- line: 1039
	-- upvalues: proto (copy)
	local t23 = {}

	if p15.start_time_seconds ~= nil then
		t23.startTimeSeconds = proto.json.serializeNumber(p15.start_time_seconds)
	end

	if p15.end_time_seconds ~= nil then
		t23.endTimeSeconds = proto.json.serializeNumber(p15.end_time_seconds)
	end

	return t23
end
function t21.jsonDecode(t24: {[any]: any}) -- line: 1055
	-- upvalues: t21 (copy), proto (copy)
	local v175 = t21.new()

	if t24.start_time_seconds ~= nil then
		v175.start_time_seconds = proto.json.deserializeNumber(t24.start_time_seconds)
	end

	if t24.startTimeSeconds ~= nil then
		v175.start_time_seconds = proto.json.deserializeNumber(t24.startTimeSeconds)
	end

	if t24.end_time_seconds ~= nil then
		v175.end_time_seconds = proto.json.deserializeNumber(t24.end_time_seconds)
	end

	if t24.endTimeSeconds ~= nil then
		v175.end_time_seconds = proto.json.deserializeNumber(t24.endTimeSeconds)
	end

	return v175
end

t21.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_TrimEdit",
	fullName = "roblox.apppageplatform.shared.v1beta1.TrimEdit"
}
t1.MomentData_MomentMetadata_MomentEdits_TrimEdit = t21
typeRegistry.default:register(t1.MomentData_MomentMetadata_MomentEdits_TrimEdit)

local t25 = {}

t25.__index = t25

function t25.new(t26: {[any]: any}?) -- line: 1094
	-- upvalues: t25 (copy)
	return (setmetatable({
		position = if t26 ~= nil and t26.position ~= nil then t26.position else {},
		rotation = if t26 ~= nil and t26.rotation ~= nil then t26.rotation else nil,
		scale = if t26 ~= nil and t26.scale ~= nil then t26.scale else nil,
		text = if t26 ~= nil and t26.text ~= nil then t26.text else nil,
		style = if t26 ~= nil and t26.style ~= nil then t26.style else nil,
		z_index = if t26 ~= nil and t26.z_index ~= nil then t26.z_index else nil
	}, t25))
end
function t25.encode(p16) -- line: 1110
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.position ~= nil and #p16.position > 0 then
		local buf7 = buffer.create(0)
		local n12 = 0

		for _, v183 in p16.position do
			buf7, n12 = proto.writeFloat(buf7, n12, v183)
		end

		local v184, v185 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v184, v185, buf7, n12)
	end

	if p16.rotation ~= nil then
		local v186, v187 = proto.writeTag(buf, n11, 2, proto.wireTypes.i32)

		buf, n11 = proto.writeFloat(v186, v187, p16.rotation)
	end

	if p16.scale ~= nil then
		local v188, v189 = proto.writeTag(buf, n11, 3, proto.wireTypes.i32)

		buf, n11 = proto.writeFloat(v188, v189, p16.scale)
	end

	if p16.text ~= nil then
		local v190, v191 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v190, v191, p16.text)
	end

	if p16.style ~= nil then
		local v192 = p16.style:encode()
		local v193, v194 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v193, v194, v192, buffer.len(v192))
	end

	if p16.z_index ~= nil then
		local v195, v196 = proto.writeTag(buf, n11, 6, proto.wireTypes.varint)

		buf, n11 = proto.writeVarInt(v195, v196, p16.z_index)
	end

	local buf8 = buffer.create(n11)

	buffer.copy(buf8, 0, buf, 0, n11)

	return buf8
end
function t25.decode(p17: buffer) -- line: 1159
	-- upvalues: t25 (copy), proto (copy), t1 (copy)
	local v199 = t25.new()
	local n13 = 0

	while n13 < buffer.len(p17) do
		local v201, v202

		v201, v202, n13 = proto.readTag(p17, n13)

		if v202 == proto.wireTypes.varint then
			if v201 == 6 then
				local v203

				v203, n13 = proto.readVarIntI32(p17, n13)
				v199.z_index = v203
			else
				local v204

				v204, n13 = proto.readVarInt(p17, n13)
			end
		elseif v202 == proto.wireTypes.lengthDelimited then
			if v201 == 1 then
				local v205

				v205, n13 = proto.readVarInt(p17, n13)

				local v206 = n13 + v205

				while n13 < v206 do
					local v207

					v207, n13 = proto.readFloat(p17, n13)
					table.insert(v199.position, v207)
				end
			elseif v201 == 4 then
				local v208

				v208, n13 = proto.readBuffer(p17, n13)
				v199.text = buffer.tostring(v208)
			elseif v201 == 5 then
				local v209

				v209, n13 = proto.readBuffer(p17, n13)
				v199.style = t1.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style.decode(v209)
			else
				local v210, v211 = proto.readVarInt(p17, n13)

				n13 = v211 + v210
			end
		elseif v202 == proto.wireTypes.i32 then
			if v201 == 1 then
				local v212

				v212, n13 = proto.readFloat(p17, n13)
				table.insert(v199.position, v212)
			elseif v201 == 2 then
				local v213

				v213, n13 = proto.readFloat(p17, n13)
				v199.rotation = v213
			elseif v201 == 3 then
				local v214

				v214, n13 = proto.readFloat(p17, n13)
				v199.scale = v214
			else
				local v215

				v215, n13 = proto.readFixed32(p17, n13)
			end
		elseif v202 == proto.wireTypes.i64 then
			local v216

			v216, n13 = proto.readFixed64(p17, n13)
		else
			error("Unsupported wire type: " .. v202)
		end
	end

	return v199
end
function t25.jsonEncode(p18) -- line: 1242
	-- upvalues: proto (copy)
	local t27 = {}

	if p18.position ~= nil and #p18.position > 0 then
		local t28 = {}

		for _, v221 in p18.position do
			table.insert(t28, proto.json.serializeNumber(v221))
		end

		t27.position = t28
	end

	if p18.rotation ~= nil then
		t27.rotation = proto.json.serializeNumber(p18.rotation)
	end

	if p18.scale ~= nil then
		t27.scale = proto.json.serializeNumber(p18.scale)
	end

	if p18.text ~= nil then
		t27.text = p18.text
	end

	if p18.style ~= nil then
		t27.style = p18.style:jsonEncode()
	end

	if p18.z_index ~= nil then
		t27.zIndex = p18.z_index
	end

	return t27
end
function t25.jsonDecode(t29: {[any]: any}) -- line: 1278
	-- upvalues: t25 (copy), proto (copy), t1 (copy)
	local v223 = t25.new()

	if t29.position ~= nil then
		local t30 = {}

		for _, v226 in t29.position do
			table.insert(t30, proto.json.deserializeNumber(v226))
		end

		v223.position = t30
	end

	if t29.rotation ~= nil then
		v223.rotation = proto.json.deserializeNumber(t29.rotation)
	end

	if t29.scale ~= nil then
		v223.scale = proto.json.deserializeNumber(t29.scale)
	end

	if t29.text ~= nil then
		v223.text = t29.text
	end

	if t29.style ~= nil then
		v223.style = t1.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style.jsonDecode(t29.style)
	end

	if t29.z_index ~= nil then
		v223.z_index = t29.z_index
	end

	if t29.zIndex ~= nil then
		v223.z_index = t29.zIndex
	end

	return v223
end

t25.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_TextOverlay",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextOverlay"
}
t1.MomentData_MomentMetadata_MomentEdits_TextOverlay = t25
typeRegistry.default:register(t1.MomentData_MomentMetadata_MomentEdits_TextOverlay)

local t31 = {}

t31.__index = t31

function t31.new(t32: {[any]: any}?) -- line: 1335
	-- upvalues: t31 (copy)
	return (setmetatable({
		font = if t32 ~= nil and t32.font ~= nil then t32.font else nil,
		font_color = if t32 ~= nil and t32.font_color ~= nil then t32.font_color else {},
		font_size = if t32 ~= nil and t32.font_size ~= nil then t32.font_size else nil,
		text_x_alignment = if t32 ~= nil and t32.text_x_alignment ~= nil then t32.text_x_alignment else nil
	}, t31))
end
function t31.encode(p19) -- line: 1349
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n14 = 0

	if p19.font ~= nil then
		local v231, v232 = proto.writeTag(buf, n14, 1, proto.wireTypes.lengthDelimited)

		buf, n14 = proto.writeString(v231, v232, p19.font)
	end

	if p19.font_color ~= nil and #p19.font_color > 0 then
		local buf9 = buffer.create(0)
		local n15 = 0

		for _, v236 in p19.font_color do
			buf9, n15 = proto.writeFloat(buf9, n15, v236)
		end

		local v237, v238 = proto.writeTag(buf, n14, 2, proto.wireTypes.lengthDelimited)

		buf, n14 = proto.writeBuffer(v237, v238, buf9, n15)
	end

	if p19.font_size ~= nil then
		local v239, v240 = proto.writeTag(buf, n14, 3, proto.wireTypes.i32)

		buf, n14 = proto.writeFloat(v239, v240, p19.font_size)
	end

	if p19.text_x_alignment ~= nil then
		local v241, v242 = proto.writeTag(buf, n14, 4, proto.wireTypes.lengthDelimited)

		buf, n14 = proto.writeString(v241, v242, p19.text_x_alignment)
	end

	local buf10 = buffer.create(n14)

	buffer.copy(buf10, 0, buf, 0, n14)

	return buf10
end
function t31.decode(p20: buffer) -- line: 1387
	-- upvalues: t31 (copy), proto (copy)
	local v245 = t31.new()
	local n16 = 0

	while n16 < buffer.len(p20) do
		local v247, v248

		v247, v248, n16 = proto.readTag(p20, n16)

		if v248 == proto.wireTypes.varint then
			local v249

			v249, n16 = proto.readVarInt(p20, n16)
		elseif v248 == proto.wireTypes.lengthDelimited then
			if v247 == 1 then
				local v250

				v250, n16 = proto.readBuffer(p20, n16)
				v245.font = buffer.tostring(v250)
			elseif v247 == 2 then
				local v251

				v251, n16 = proto.readVarInt(p20, n16)

				local v252 = n16 + v251

				while n16 < v252 do
					local v253

					v253, n16 = proto.readFloat(p20, n16)
					table.insert(v245.font_color, v253)
				end
			elseif v247 == 4 then
				local v254

				v254, n16 = proto.readBuffer(p20, n16)
				v245.text_x_alignment = buffer.tostring(v254)
			else
				local v255, v256 = proto.readVarInt(p20, n16)

				n16 = v256 + v255
			end
		elseif v248 == proto.wireTypes.i32 then
			if v247 == 2 then
				local v257

				v257, n16 = proto.readFloat(p20, n16)
				table.insert(v245.font_color, v257)
			elseif v247 == 3 then
				local v258

				v258, n16 = proto.readFloat(p20, n16)
				v245.font_size = v258
			else
				local v259

				v259, n16 = proto.readFixed32(p20, n16)
			end
		elseif v248 == proto.wireTypes.i64 then
			local v260

			v260, n16 = proto.readFixed64(p20, n16)
		else
			error("Unsupported wire type: " .. v248)
		end
	end

	return v245
end
function t31.jsonEncode(p21) -- line: 1460
	-- upvalues: proto (copy)
	local t33 = {}

	if p21.font ~= nil then
		t33.font = p21.font
	end

	if p21.font_color ~= nil and #p21.font_color > 0 then
		local t34 = {}

		for _, v265 in p21.font_color do
			table.insert(t34, proto.json.serializeNumber(v265))
		end

		t33.fontColor = t34
	end

	if p21.font_size ~= nil then
		t33.fontSize = proto.json.serializeNumber(p21.font_size)
	end

	if p21.text_x_alignment ~= nil then
		t33.textXAlignment = p21.text_x_alignment
	end

	return t33
end
function t31.jsonDecode(t35: {[any]: any}) -- line: 1488
	-- upvalues: t31 (copy), proto (copy)
	local v267 = t31.new()

	if t35.font ~= nil then
		v267.font = t35.font
	end

	if t35.font_color ~= nil then
		local t36 = {}

		for _, v270 in t35.font_color do
			table.insert(t36, proto.json.deserializeNumber(v270))
		end

		v267.font_color = t36
	end

	if t35.fontColor ~= nil then
		local t37 = {}

		for _, v273 in t35.fontColor do
			table.insert(t37, proto.json.deserializeNumber(v273))
		end

		v267.font_color = t37
	end

	if t35.font_size ~= nil then
		v267.font_size = proto.json.deserializeNumber(t35.font_size)
	end

	if t35.fontSize ~= nil then
		v267.font_size = proto.json.deserializeNumber(t35.fontSize)
	end

	if t35.text_x_alignment ~= nil then
		v267.text_x_alignment = t35.text_x_alignment
	end

	if t35.textXAlignment ~= nil then
		v267.text_x_alignment = t35.textXAlignment
	end

	return v267
end

t31.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_TextOverlay_Style",
	fullName = "roblox.apppageplatform.shared.v1beta1.Style"
}
t1.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style = t31
typeRegistry.default:register(t1.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style)

return {
	MomentData = t1.MomentData,
	MomentData_MomentMetadata = t1.MomentData_MomentMetadata,
	MomentData_MomentMetadata_MomentEdits = t1.MomentData_MomentMetadata_MomentEdits,
	MomentData_MomentMetadata_MomentEdits_MusicEdit = t1.MomentData_MomentMetadata_MomentEdits_MusicEdit,
	MomentData_MomentMetadata_MomentEdits_TrimEdit = t1.MomentData_MomentMetadata_MomentEdits_TrimEdit,
	MomentData_MomentMetadata_MomentEdits_TextOverlay = t1.MomentData_MomentMetadata_MomentEdits_TextOverlay,
	MomentData_MomentMetadata_MomentEdits_TextOverlay_Style = t1.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style
}
