class Shipping < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: [:update], owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }

  has_and_belongs_to_many :users
  has_many :orders
  has_many :customers, through: :orders

  validates :ship_date, presence: true
  validates :order_fields, presence: true

  scope :this_month, -> { where("ship_date >= ?", Time.now.beginning_of_month) }

  before_save :set_default

  #get next available shipment
  def next
    shipment = self.class.includes(:users).where("id > ?", id).first
    if shipment
      shipment
    else
      self.class.first
    end
  end

  #get previous shipment
  def prev
    shipment = self.class.includes(:users).where("id < ?", id).first
    if shipment
      shipment
    else
      self.class.last
    end
  end

  def calculate_ship_vn
    self.price / Order.where(shipping_id: self.id).count
  end

  private

    def set_default
      self.ship_date = Time.now if self.ship_date.nil?
      self.price = 0 if self.price.nil?
    end
    
end
