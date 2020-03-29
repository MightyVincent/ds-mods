local assets = ARCHERYFUNCS.GenerateSkinAssets("z_bow_skin_jungle")

return CreatePrefabSkin("z_bow_skin_jungle",
{
	base_prefab = "bow",
	type = "item",
	assets = assets,
	build_name = "swap_z_bow_skin_jungle",
	rarity = "Elegant",
	init_fn = function(inst) end,
})