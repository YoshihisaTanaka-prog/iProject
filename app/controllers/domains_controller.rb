class DomainsController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}
    layout 'autho', only: [:index]

    def index
        object = NCMB::DataStore.new "Domain"
        @s_obj = NCMB::DataStore.new "ShortenCollageName"
        @p_obj = NCMB::DataStore.new "CollegePrefecture"
        if !params['cn'].blank?
            object1 = NCMB::DataStore.new "Domain"
            @objects = object1.where("collage", params['cn'])
        elsif !params['dom'].blank?
            object2 = NCMB::DataStore.new "Domain"
            @objects = object1.where("domain", params['dom'])
        elsif params['status'].blank?
            @collages = CollageStatus.all.order(:collage_name).page(params[:page])
            collage_names = []
            @collages.each do |c|
                collage_names.push(c.collage_name)
            end
            if collage_names.blank?
                @objects = []
            else
                @objects = object.in("collage", collage_names).order("collage")
            end
        elsif params['status'] == "-2"
            @collages = CollageStatus.all.order(:collage_name).page(params[:page])
            collage_names = []
            @collages.each do |c|
                collage_names.push(c.collage_name)
            end
            if collage_names.blank?
                @objects = []
            else
                @objects = object.in("collage", collage_names).order("collage")
            end
        elsif params["status"] == '-1'
            @objects = object.equalTo("checked", false)
        else
            @collages = CollageStatus.where(status: params['status']).order(:collage_name).page(params[:page])
            collage_names = []
            @collages.each do |c|
                collage_names.push(c.collage_name)
            end
            if collage_names.blank?
                @objects = []
            else
                @objects = object.in("collage", collage_names).order("collage")
            end
        end
    end

    def create
        object = NCMB::DataStore.new "Domain"
        if object.where("domain", params["dom"]).first.blank?
            domain = object.new(domain: params["dom"], collage: params["collage"], checked: false, parmitted: false)
            domain.acl = nil
            domain.save
            if CollageStatus.where(collage_name: params["collage"]).blank?
                c = CollageStatus.new()
                c.collage_name = params["collage"]
                c.save
            end
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
        if params["page"].blank?
            redirect_to autho_domain_path(:status => params["status"])
        else
            redirect_to autho_domain_path(:page => params["page"], :status => params["status"])
        end
    end

    def edit
        object = NCMB::DataStore.new "Domain"
        p_obj = NCMB::DataStore.new "CollegePrefecture"
        s_obj = NCMB::DataStore.new "ShortenCollageName"
        if params["id"].blank?
            @objects = object.where("domain", params["dom"])
        else
            @objects = object.where("objectId", params["id"])
        end
        obj = @objects.first
        @id = obj.objectId
        @domain = obj.domain
        @collage = obj.collage
        @prefecture = p_obj.where("collageName", @collage)
        @shorten = s_obj.where("collageName", @collage)
        # 編集状況の確認
        c_status = CollageStatus.where(collage_name: obj.collage)
        if c_status.blank?
            @status = CollageStatus.new
            @status.collage_name = obj.collage
            @status.save
        else
            @status = c_status.first
        end
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
        c = CollageStatus.where(collage_name: params['c']).first
        if c.blank?
            c = CollageStatus.new
            c.collage_name = params['c']
            c.creator_id = current_admin.id
            c.status = 1
            c.save
        elsif c.creator_id == -1
            c.creator_id = current_admin.id
            c.status = 1
            c.save
        end
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
                end
            end
            c = CollageStatus.where(collage_name: params['cn']).first
            if c.blank?
                c = CollageStatus.new
                c.collage_name = params['cn']
                c.creator_id = current_admin.id
                c.status = 1
                c.save
            elsif c.creator_id == -1
                c.creator_id = current_admin.id
                c.status = 1
                c.save
            end
            redirect_to autho_domain_edit_path(:id => params['d_id'], :status => params['status'], :cn => params["cn"])
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
        if params['old_collage'] != params['collage']
            c = CollageStatus.where(collage_name: params['old_collage']).first
            if c.blank?
                c = CollageStatus.new
                c.collage_name = params['collage']
                c.save
            else
                c.collage_name = params['collage']
                c.save
            end
        end
        redirect_to autho_domain_path(:status => params["status"], :cn => params["collage"])
    end

end
