class DomainsController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}
    before_action -> { group_limit(1)}
    layout 'autho', only: [:index]

    def index
        object = NCMB::DataStore.new "Domain"
        @s_obj = NCMB::DataStore.new "ShortenCollageName"
        @p_obj = NCMB::DataStore.new "CollegePrefecture"
        if !params['cn'].blank?
            @objects = object.where("collage", params['cn'])
        elsif params["status"].blank?
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
                @objects = object.where("parmitted", "false")
                @objects = object.where("checked", "false")
            end
        end
    end

    def create
        object = NCMB::DataStore.new "Domain"
        if object.where("domain", params["dom"]).first.blank?
            domain = object.new(domain: params["dom"], collage: params["collage"], checked: false, parmitted: false)
            domain.acl = nil
            domain.save
            redirect_to autho_domain_path(:status => params['status'], :cn => params["cn"])
        else
            msg = "ドメインが存在するので、編集画面にリダイレクトしました。"
            d = params["dom"]
            redirect_to autho_domain_edit_path(:dom => d, :msg => msg, :status => params['status'], :cn => params["cn"])
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
        redirect_to autho_domain_path(:status => params["status"], :cn => params["cn"])
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
        redirect_to autho_domain_edit_path(:id => params['id'], :status => params['status'], :cn => params["cn"])
    end

    def add_shorten
        d_obj = NCMB::DataStore.new "Domain"
        s_obj = NCMB::DataStore.new "ShortenCollageName"
        if request.post?   
            if params["s_id"].blank?
                c = d_obj.where("objectId", params['d_id']).first.collage
                if c == params['name']
                    redirect_to autho_domain_edit_path(:id => params['d_id'], :status => params['status'], :cn => params["cn"], :msg => "大学名が省略されていません！")
                else 
                    s = s_obj.new(collageName: c, shortenName: params['name'])
                    s.acl = nil
                    s.save
                    redirect_to autho_domain_edit_path(:id => params['d_id'], :status => params['status'], :cn => params["cn"])
                end
            else
                c = d_obj.where("objectId", params['d_id']).first.collage
                s = s_obj.where('objectId', params['s_id']).first
                if c == params['name']
                    redirect_to autho_domain_edit_path(:id => params['d_id'], :status => params['status'], :cn => params["cn"], :msg => "大学名が省略されていません！")
                else
                    s.objectId = params['s_id']
                    s.collageName = c
                    s.shortenName = params['name']
                    s.acl = nil
                    s.save
                    redirect_to autho_domain_edit_path(:id => params['d_id'], :status => params['status'], :cn => params["cn"])
                end
            end
        else   
            if params["s_id"].blank?
                @c = d_obj.where("objectId", params['d_id']).first.collage
            else
                @c = d_obj.where("objectId", params['d_id']).first.collage
                @obj = s_obj.where("objectId", params['s_id']).first
            end
        end
    end

    def update
        object = NCMB::DataStore.new "Domain"
        domain = object.where("objectId", params["id"]).first
        domain.objectId = params['id']
        domain.domain = params['dom']
        domain.collage = params['collage']
        domain.acl = nil
        domain.save
        redirect_to autho_domain_path(:status => params["status"], :cn => params["cn"])
    end

end
