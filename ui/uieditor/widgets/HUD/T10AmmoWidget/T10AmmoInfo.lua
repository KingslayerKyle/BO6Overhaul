local SetAmmoText = function ( controller, element )
	local controllerModel = Engine.GetModelForController( controller )
	local ammoInClipModel = Engine.GetModel( controllerModel, "currentWeapon.ammoInClip" )
	local ammoInDWClipModel = Engine.GetModel( controllerModel, "currentWeapon.ammoInDWClip" )
	local ammoInClip = Engine.GetModelValue( ammoInClipModel )
	local ammoInDWClip = Engine.GetModelValue( ammoInDWClipModel )

	if ammoInClip ~= nil and ammoInDWClip ~= nil then
		local ammoClipColor = "^7"
		local ammoDWClipColor = "^7"

		if IsLowAmmoClip( controller ) then
			ammoClipColor = "^1"
		end

		if IsLowAmmoDWClip( controller ) then
			ammoDWClipColor = "^1"
		end

		local ammoClipText = (ammoClipColor .. tostring( ammoInClip ))
		local ammoDWClipText = (ammoDWClipColor .. tostring( ammoInDWClip ))

		if ammoInDWClip ~= -1 then
			element:setText( ammoDWClipText .. " " .. ammoClipText )
		else
			element:setText( ammoClipText )
		end
	end
end

CoD.T10AmmoInfo = InheritFrom( LUI.UIElement )
CoD.T10AmmoInfo.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10AmmoInfo )
	self.id = "T10AmmoInfo"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

    self.AmmoClip = LUI.UIText.new()
    self.AmmoClip:setLeftRight( true, true, 0, 145 )
    self.AmmoClip:setTopBottom( false, true, -92, 3 )
    self.AmmoClip:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.AmmoClip:setScale( 0.5 )
	self.AmmoClip:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.AmmoClip:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.ammoInClip" ), function ( model )
		SetAmmoText( controller, self.AmmoClip )
	end )
	self.AmmoClip:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.ammoInDWClip" ), function ( model )
		SetAmmoText( controller, self.AmmoClip )
	end )
	self.AmmoClip:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.viewmodelWeaponName" ), function ( model )
		SetAmmoText( controller, self.AmmoClip )
	end )
    self:addElement( self.AmmoClip )

	self.AmmoStock = LUI.UIText.new()
    self.AmmoStock:setLeftRight( true, true, 0, 205 )
    self.AmmoStock:setTopBottom( false, true, -71, -25 )
	self.AmmoStock:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.AmmoStock:setRGB( 0.8, 0.8, 0.8 )
	self.AmmoStock:setScale( 0.5 )
	self.AmmoStock:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.AmmoStock:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.ammoStock" ), function ( model )
		local ammoStock = Engine.GetModelValue( model )

		if ammoStock then
			if ammoStock == 0 then
				self.AmmoStock:setRGB( 1, 0.2, 0.2 )
			else
				self.AmmoStock:setRGB( 0.8, 0.8, 0.8 )
			end
			
			self.AmmoStock:setText( Engine.Localize( string.format( "%03d", ammoStock ) ) )
		end
	end )
	self:addElement( self.AmmoStock )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 1 )
				self.clipFinished( self.AmmoClip, {} )

				self.AmmoStock:completeAnimation()
				self.AmmoStock:setAlpha( 1 )
				self.clipFinished( self.AmmoStock, {} )
			end,
			AmmoPulse = function ()
				self:setupElementClipCounter( 1 )
			
				local AmmoPulseTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
					end
	
					element:setTopBottom( false, true, -95, 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setTopBottom( false, true, -92, 3 )
				AmmoPulseTransition( self.AmmoClip, {} )
			end
		},
		AmmoPulse = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )
				
				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 1 )
				self.clipFinished( self.AmmoClip, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 1 )
			
				local AmmoPulseTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
					end
	
					element:setTopBottom( false, true, -92, 3 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setTopBottom( false, true, -95, 0 )
				AmmoPulseTransition( self.AmmoClip, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )

				self.AmmoClip:completeAnimation()
				self.AmmoClip:setAlpha( 0 )
				self.clipFinished( self.AmmoClip, {} )

				self.AmmoStock:completeAnimation()
				self.AmmoStock:setAlpha( 0 )
				self.clipFinished( self.AmmoStock, {} )
			end
		}
	}
	
	self:mergeStateConditions( {
		{
			stateName = "AmmoPulse",
			condition = function ( menu, element, event )
				return PulseNoAmmo( controller )
			end
		},
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				if not WeaponUsesAmmo( controller )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "minigun_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "cymbal_monkey_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "octobomb_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "frag_grenade_zm" )
				or IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "sticky_grenade_widows_wine_zm" )
				or ModelValueStartsWith( controller, "currentWeapon.viewmodelWeaponName", "hero_wand_" )
				or ModelValueStartsWith( controller, "currentWeapon.viewmodelWeaponName", "zombie_" ) then
					return true
				else
					return false
				end
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.pulseNoAmmo" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.pulseNoAmmo"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.viewmodelWeaponName" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "currentWeapon.viewmodelWeaponName"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.AmmoClip:close()
		element.AmmoStock:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
