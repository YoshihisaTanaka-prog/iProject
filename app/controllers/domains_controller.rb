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
        f_obj = NCMB::DataStore.new "CollageFaculty"
        if params["id"].blank?
            if params['dom'].blank?
                redirect_to autho_domain_path
            end
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
        @faculty = f_obj.where("collageName", @collage)
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
        change_status(params["c"],1)
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
            change_status(params["cn"],1)
            redirect_to autho_domain_edit_path(:id => params['d_id'], :cn => params["cn"], :status => params['status'])
        else   
            if params["s_id"].blank?
                @c = d_obj.where("objectId", params['d_id']).first.collage
            else
                @c = d_obj.where("objectId", params['d_id']).first.collage
                @obj = s_obj.where("objectId", params['s_id']).first
            end
        end
    end

    def add_faculty
        object = NCMB::DataStore.new "CollageFaculty"
        if request.post?
            collage_faculty = object.new(collageName: params['cn'], facultyName: params['name'])
            collage_faculty.acl = nil
            collage_faculty.save
            change_status(params["cn"],1)
            redirect_to autho_domain_department_path(:d_id => params['d_id'], :cn => params["cn"], :fn => params['name'], :status => params['status'])
        else
            @collage_facultys = object.equalTo("collageName", params['cn'])
        end
    end

    def add_department
        cd_obj = NCMB::DataStore.new "Department"
        if request.post?
            dep = cd_obj.new(collageFacultyId: params['cf_id'],departmentName: params['name'])
            dep.acl = nil
            dep.save
            redirect_to autho_domain_department_path(:d_id => params['d_id'], :cn => params["cn"], :fn => params['fn'], :status => params['status'])
        else
            cf_obj = NCMB::DataStore.new "CollageFaculty"
            @collage_facultys = cf_obj.equalTo("collageName", params["cn"]).equalTo("facultyName", params["fn"])
            if @collage_facultys.blank?
                redirect_to autho_domain_faculty_path(:d_id => params['d_id'], :cn => params["cn"], :status => params['status'])
            else
                @cf_id = @collage_facultys.first.objectId
                @collage_departments = cd_obj.equalTo("collageFacultyId", @cf_id)
            end
        end
    end

    def finish_create
        change_status(params["cn"],2)
        redirect_to autho_domain_edit_path(:cn => params["cn"], :id => params["id"], :status => params['status'])
    end

    def finish_check
        strongest_limit
        change_status(params["cn"],3)
        redirect_to autho_domain_edit_path(:cn => params["cn"], :id => params["id"], :status => params['status'])
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

    # 圧縮用関数

    def change_status(collage_name, status_num)
        cs = CollageStatus.where(collage_name: collage_name).first
        if cs.blank?
            cs = CollageStatus.new
            cs.collage_name = collage_name
            case status_num
            when 1
                cs.creator_id = current_admin.id
            when 2
                cs.creator_id = current_admin.id
            when 3
                cs.creator_id = current_admin.id
                cs.checker_id = current_admin.id
            end
            cs.status = status_num
            cs.save
        else
            case status_num
            when 1
                if cs.creator_id == -1 
                    cs.creator_id = current_admin.id
                    cs.status = status_num
                    cs.save
                end
            when 2
                if cs.status == 1 && cs.creator_id == current_admin.id
                    cs.status = status_num
                    cs.save
                end
            when 3
                if cs.status == 2  
                    cs.checker_id = current_admin.id
                    cs.status = status_num
                    cs.save
                end
            end
        end
    end

end
