class DomainsController < ApplicationController
    before_action :authenticate_admin!
    before_action :make_option , only: [:index]

    def index
        object = NCMB::DataStore.new "Domain"
        @s_obj = NCMB::DataStore.new "ShortenCollageName"
        @p_obj = NCMB::DataStore.new "CollegePrefecture"
        if params["status"].blank?
            @objects = object.all
        else
            case params["status"].to_i
            when 0 then
                @objects = object.all
            when 1 then
                @objects = object.where("checked", false)
            when 2 then
                @objects = object.where("checked", true).where("parmitted", true)
            when 3 then
                @objects = object.where("checked", true).where("parmitted", false)
            else
                obj1 = object.where("checked", "true")
                obj2 = object.where("checked", "false")
                obj3 = object.where("parmitted", "true")
                obj4 = object.where("parmitted", "false")
                @objects = []
                obj1.each do |o|
                    @objects.push(o)
                end
                obj2.each do |o|
                    @objects.push(o)
                end
                obj3.each do |o|
                    @objects.push(o)
                end
                obj4.each do |o|
                    @objects.push(o)
                end
            end
        end
    end

    def create
        object = NCMB::DataStore.new "Domain"
        if object.where("domain", params["dom"]).first.blank?
            domain = object.new(domain: params["dom"], collage: params["collage"], shortenCollege: params["shortenCollege"], prefecture: params["prefecture"], checked: false, parmitted: false)
            domain.acl = nil
            domain.save
            redirect_to autho_domain_path
        else
            msg = "ドメインが存在するので、編集画面にリダイレクトしました。"
            d = params["dom"]
            redirect_to autho_domain_edit_path(:dom => d, :msg => msg, :status => params['status'])
        end
    end

    def change
        object = NCMB::DataStore.new "Domain"
        obj = object.where("objectId", params["id"]).first
        obj.checked = true
        if params["parmitted"] == 'true'
            obj.parmitted = true
        else
            obj.parmitted = false
        end
        
        obj.acl = nil
        obj.save
        redirect_to autho_domain_path(:status => params["status"])
    end

    def edit
        object = NCMB::DataStore.new "Domain"
        p_obj = NCMB::DataStore.new "CollegePrefecture"
        s_obj = NCMB::DataStore.new "ShortenCollageName"
        @objects = object.where("objectId", params["id"])
        obj = @objects.first
        @id = obj.objectId
        @domain = obj.domain
        @collage = obj.collage
        @prefecture = p_obj.where("collageName", @collage)
        @shorten = s_obj.where("collageName", @collage)
    end

    def select
        if params['d'].blank?
            redirect_to autho_domain_path
        end

        d_obj = NCMB::DataStore.new "Domain"
        r_obj = NCMB::DataStore.new "Region"
        p_obj = NCMB::DataStore.new "Prefecture"
        @dom = d_obj.where("objectId", params['d']).first
        if params['r'].blank?
            @reg = r_obj.all
            @pre = p_obj.all
        else
            @reg = r_obj.where("objectId", params['r']).first
            @pre = p_obj.where("regionId", params['r'])
        end
    end

    def add_prefecture
        object = NCMB::DataStore.new "CollegePrefecture"
        cp = object.new(collageName: params['c'], prefecture: params['p'])
        cp.acl = nil
        cp.save
        redirect_to autho_domain_edit_path(:id => params['id'])
    end

    def update
        object = NCMB::DataStore.new "Domain"
        domain = object.where("objectId", params["id"]).first
        domain.objectId = params['id']
        domain.domain = params['dom']
        domain.collage = params['collage']
        domain.acl = nil
        domain.save
        redirect_to autho_domain_path(:status => params["status"])
    end

end
