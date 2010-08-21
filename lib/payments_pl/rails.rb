Payments.init(File.join(Rails.root, 'config', 'payments.yml'))
ActionView::Base.send(:include, Payments::ViewHelpers)