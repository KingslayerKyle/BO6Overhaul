require( "ui.uieditor.widgets.T10WeaponUpgrade.T10WeaponUpgradeButton1ListItem" )

CoD.ZMWeaponRarities = {
	{
		name = "No Tier",
		r = 0.3,
		g = 0.3,
		b = 0.3
	},
	{
		name = "^2Uncommon^7",
		cost = 500,
		description = "Uncommon | Tier 2 Damage",
		image = "ximage_c7a30b835db022",
		banner = "ximage_c17988707cb5808",
		r = 0,
		g = 0.4,
		b = 0
	},
	{
		name = "^5Rare^7",
		cost = 1500,
		description = "Rare | Tier 3 Damage",
		image = "ximage_309dc516e1ddb",
		banner = "ximage_6cba6cea7cbc2df",
		r = 0,
		g = 0.4,
		b = 0.7
	},
	{
		name = "^6Epic^7",
		cost = 4000,
		description = "Epic | Tier 4 Damage",
		image = "ximage_4af7682c8ea721a",
		banner = "ximage_c60dc585628a330",
		r = 0.5,
		g = 0.2,
		b = 0.5
	},
	{
		name = "^3Legendary^7",
		cost = 9000,
		description = "Legendary | Tier 5 Damage",
		image = "ximage_540fc5abb3f3ed8",
		banner = "ximage_b805aca61ce3c74",
		r = 0.7,
		g = 0.3,
		b = 0
	},
	{
		name = "Wonder Weapon",
		r = 0.7,
		g = 0.5,
		b = 0
	}
}

DataSources.T10WeaponUpgradeTabWidget2 = ListHelper_SetupDataSource( "T10WeaponUpgradeTabWidget2", function ( controller )
	local weaponTiers = {}

	local weaponTierModel = Engine.GetModel( Engine.GetModelForController( controller ), "t10_weapon_upgrade_tier" )
	local weaponTier = Engine.GetModelValue( weaponTierModel )
	local junkModel = Engine.GetModel( Engine.GetModelForController( controller ), "t10_junk" )
	local junk = Engine.GetModelValue( junkModel )

	if CoD.ZMWeaponRarities ~= nil and weaponTier ~= nil then
		for index = 1, #CoD.ZMWeaponRarities do
			local cost = CoD.ZMWeaponRarities[index].cost

			if cost ~= nil then
				cost = cost - (CoD.ZMWeaponRarities[weaponTier + 1] and CoD.ZMWeaponRarities[weaponTier + 1].cost or 0)

				table.insert( weaponTiers, {
					models = {
						name = CoD.ZMWeaponRarities[index].name,
						cost = cost,
						description = CoD.ZMWeaponRarities[index].description,
						image = CoD.ZMWeaponRarities[index].image,
						banner = CoD.ZMWeaponRarities[index].banner,
						owned = weaponTier == index - 1,
						junk = junk,
						action = function ( self, element, controller, actionParam, menu )
							Engine.SendMenuResponse( controller, "T10WeaponUpgrade_Main", "tier|" .. cost .. "," .. index - 1 )
						end
					}
				} )
			end
		end
	end

	return weaponTiers
end, true )

local SetHeaderLabels = function ( self, controller )
	local controllerModel = Engine.GetModelForController( controller )
	local buttonListModel = self.buttonList:getModel()

	local nameModel = Engine.GetModel( buttonListModel, "name" )
	local costModel = Engine.GetModel( buttonListModel, "cost" )
	local descriptionModel = Engine.GetModel( buttonListModel, "description" )
	local ownedModel = Engine.GetModel( buttonListModel, "owned" )
	local junkModel = Engine.GetModel( buttonListModel, "junk" )
	local weaponTierModel = Engine.GetModel( controllerModel, "t10_weapon_upgrade_tier" )
	local weaponNameModel = Engine.GetModel( controllerModel, "currentWeapon.weaponName" )

	local name = Engine.GetModelValue( nameModel )
	local cost = Engine.GetModelValue( costModel )
	local description = Engine.GetModelValue( descriptionModel )
	local owned = Engine.GetModelValue( ownedModel )
	local junk = Engine.GetModelValue( junkModel )
	local weaponTier = Engine.GetModelValue( weaponTierModel )
	local weaponName = Engine.GetModelValue( weaponNameModel )

	if name ~= nil and cost ~= nil and description ~= nil and owned ~= nil and junk ~= nil and weaponTier ~= nil and weaponName ~= nil then
		if self.Name ~= nil and self.Description ~= nil then
			self.Name:setScale( 0.5 )

			if owned == true then
				self.Name:setScale( 0.3 )
				self.Name:setText( string.upper( Engine.Localize( name ) .. " TIER UPGRADE FOR " .. Engine.Localize( weaponName ) .. " - ^1ALREADY PURCHASED" ) )
				self.Description:setText( Engine.Localize( description ) )
			elseif weaponTier >= 5 then
				self.Name:setText( Engine.Localize( "^1WEAPON IS INCOMPATIBLE" ) )
				self.Description:setText( Engine.Localize( "Change weapons to access ammo mods." ) )
			elseif cost > junk then
				self.Name:setScale( 0.3 )
				self.Name:setText( string.upper( Engine.Localize( name ) .. " TIER UPGRADE FOR " .. Engine.Localize( weaponName ) .. " - ^1NOT ENOUGH SALVAGE" ) )
				self.Description:setText( Engine.Localize( description ) )
			else
				self.Name:setText( string.upper( Engine.Localize( name ) .. " TIER UPGRADE FOR " .. Engine.Localize( weaponName ) ) )
				self.Description:setText( Engine.Localize( description ) )
			end			
		end
	end
end

local PostLoadFunc = function ( self, controller )
	local controllerModel = Engine.GetModelForController( controller )
	local weaponTierModel = Engine.GetModel( controllerModel, "t10_weapon_upgrade_tier" )
	local weaponNameModel = Engine.GetModel( controllerModel, "currentWeapon.weaponName" )
	local junkModel = Engine.GetModel( controllerModel, "t10_junk" )

	local models = {
		"name",
		"cost",
		"description",
		"owned",
		"junk"
	}

	for index = 1, #models do
		self:linkToElementModel( self.buttonList, models[index], true, function ( model )
			SetHeaderLabels( self, controller )
		end )
	end

	self:subscribeToModel( weaponTierModel, function ( model )
		SetHeaderLabels( self, controller )
	end )

	self:subscribeToModel( weaponNameModel, function ( model )
		SetHeaderLabels( self, controller )
	end )

	self.buttonList:subscribeToModel( weaponTierModel, function ( model )
		self.buttonList:updateDataSource()
	end )

	self.buttonList:subscribeToModel( junkModel, function ( model )
		self.buttonList:updateDataSource()
	end )
end

CoD.T10WeaponUpgradeTabWidget2 = InheritFrom( LUI.UIElement )
CoD.T10WeaponUpgradeTabWidget2.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10WeaponUpgradeTabWidget2 )
	self.id = "T10WeaponUpgradeTabWidget2"
	self.soundSet = "ChooseDecal"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self:makeFocusable()
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true
	
	self.Name = LUI.UIText.new()
	self.Name:setLeftRight( true, true, -500, 500 )
	self.Name:setTopBottom( true, false, 512, 575 )
	self.Name:setText( Engine.Localize( "" ) )
	self.Name:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Name:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Name:setRGB( 0.73, 0.73, 0.69 )
	self.Name:setScale( 0.5 )
	self:addElement( self.Name )

	self.Description = LUI.UIText.new()
	self.Description:setLeftRight( true, true, 0 - 300, 0 + 300 )
	self.Description:setTopBottom( true, false, 559.5, 589.5 )
	self.Description:setText( Engine.Localize( "" ) )
	self.Description:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.Description:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Description:setRGB( 0.65, 0.65, 0.65 )
	self.Description:setScale( 0.5 )
	self:addElement( self.Description )

	self.buttonList = LUI.UIList.new( menu, controller, 13, 0, nil, true, false, 0, 0, false, false )
	self.buttonList:makeFocusable()
	self.buttonList:setLeftRight( false, false, 0, 0 )
	self.buttonList:setTopBottom( true, true, 613.5, 0 )
	self.buttonList:setWidgetType( CoD.T10WeaponUpgradeButton1ListItem )
	self.buttonList:setHorizontalCount( 6 )
	self.buttonList:setDataSource( "T10WeaponUpgradeTabWidget2" )
	self.buttonList:registerEventHandler( "gain_focus", function ( element, event )
		local retVal = nil

		if element.gainFocus then
			retVal = element:gainFocus( event )
		elseif element.super.gainFocus then
			retVal = element.super:gainFocus( event )
		end

		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )

		return retVal
	end )
	self.buttonList:registerEventHandler( "lose_focus", function ( element, event )
		local retVal = nil

		if element.loseFocus then
			retVal = element:loseFocus( event )
		elseif element.super.loseFocus then
			retVal = element.super:loseFocus( event )
		end

		return retVal
	end )
	menu:AddButtonCallbackFunction( self.buttonList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		ProcessListAction( self, element, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )

		return true
	end, false )
	self:addElement( self.buttonList )
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		CP_PauseMenu = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "CP_PauseMenu",
			condition = function ( menu, element, event )
				return IsCampaign()
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		} )
	end )

	self.buttonList.id = "buttonList"
	
	self:registerEventHandler( "gain_focus", function ( element, event )
		if element.m_focusable and element.buttonList:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( element, event )
		end
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Name:close()
		element.Description:close()
		element.buttonList:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
