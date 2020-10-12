"""
Updates
--------

This plugin provides updates information

This plugin is not loaded by default, so to use it you will first
need to add it to your VCPs YAML config file.

YAML configuration:

.. code-block:: yaml

    data_plugins:
      updates:
        provider: qtpyvcp.plugins.updates:Updates

"""

import xml.etree.ElementTree as ET

from pycurl import Curl, URL, WRITEFUNCTION
from cStringIO import StringIO

from qtpy.QtCore import QTimer
from qtpyvcp.plugins import DataPlugin, DataChannel


class Updates(DataPlugin):
    """Clock Plugin"""
    def __init__(self):
        super(Updates, self).__init__()

        self._xml_updates = StringIO()
        self.curl = Curl()
        self.curl.setopt(URL, 'http://repository.qtpyvcp.com/repo/pb-dev/repo/Updates.xml')
        self.curl.setopt(WRITEFUNCTION, self._xml_updates.write)
        self.curl.perform()
        self.curl.close()

        self.root = ET.fromstring(self._xml_updates.getvalue())

        for package in self.root:
            if package.tag == 'PackageUpdate':
                print(package.tag)
                for package_version in package.iter('Version'):
                    print(package_version.text)

        for package in self.root.findall('PackageUpdate'):
            display_name = package.find('DisplayName').text
            version = package.find('Version').text

            print(display_name, version)


        # set initial values
        self.cur_version.setValue("")
        self.new_version.setValue("")

        # make the clock tick
        self.timer = QTimer()
        self.timer.timeout.connect(self.tick)

    @DataChannel
    def cur_version(self, chan):
        """The current version, updated every second.

        Args:
            format (str) : Format spec. Defaults to ``%I:%M:%S %p``.
                See http://strftime.org for supported formats.

        Returns:
            The current time as a formatted string. Default HH:MM:SS AM

        Channel syntax::

            updates:cur_version

        """
        return chan.value


    @DataChannel
    def new_version(self, chan):
        """The New version, updated every boot.

        Args:
            format (str) : Format spec. Defaults to ``%I:%M:%S %p``.
                See http://strftime.org for supported formats.

        Returns:
            The current version found online.

        Channel syntax::
            updates:cur_version

        """
        return chan.value

    def initialise(self):
        # self.timer.start(1000)
        pass

    def tick(self):
        # curl get version fom xml
        # self.cur_version.setValue(datetime.now())
        # self.date.setValue(datetime.now())
        pass
