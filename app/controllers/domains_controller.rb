class DomainsController < ApplicationController
    before_action :authenticate_admin!

    def index
        object = NCMB::DataStore.new "Domain"
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
            else
                @objects = object.where("checked", true).where("parmitted", false)
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
        @objects = object.where("domain", params["dom"])
        obj = @objects.first
        @domain = obj.domain
        @collage = obj.collage
        @shortenCollege = obj.shortenCollege
    end

    def update
        object = NCMB::DataStore.new "Domain"
        if params["all"].blank?
            if params["id"].blank?
                domain = object.new(domain: params["dom"], collage: params["collage"], shortenCollege: params["shortenCollege"], prefecture: params["prefecture"], checked: true, parmitted: true)
                domain.acl = nil
                domain.save
            else
                domain = object.where("objectId", params['id']).first
                domain.domain = params['dom']
                domain.collage = params['collage']
                domain.shortenCollege = params['shortenCollege']
                domain.prefecture = params['prefecture']
                domain.acl = nil
            end
        else
            domains = object.where("domain", params["dom"])
                domains.each do |domain|
                domain.domain = params['dom']
                domain.collage = params['collage']
                domain.shortenCollege = params['shortenCollege']
                domain.acl = nil
            end
        end
        redirect_to autho_domain_path(:status => params["status"])
    end

end
