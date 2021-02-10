class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def level
    if self.admin
      return "最高権限"
    elsif self.subadmin
      return "準最高権限"
    else
      return "レベル" + self.admin_level.to_s
    end
  end
end
