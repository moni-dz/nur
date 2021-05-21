#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>

#include <gio/gio.h>
#include <glib.h>
#include <glib-unix.h>

#include "tiramisu.h"
#include "notification.h"
#include "events.h"

GDBusConnection *dbus_connection = NULL;
GDBusNodeInfo *introspection = NULL;
GMainLoop *main_loop = NULL;

unsigned int notification_id = 0;
char print_json = 0;
char *delimiter = "\n";

gboolean stop_main_loop(gpointer user_data) {
    g_main_loop_quit(main_loop);

    return G_SOURCE_CONTINUE;
}

int main(int argc, char **argv) {
    /* Parse arguments */

    char argument;
    while ((argument = getopt(argc, argv, "hjd:")) >= 0) {
        switch (argument) {
            case 'd':
                delimiter = optarg;
                break;
            case 'h':
                printf("%s\n",
                    "tiramisu -[h|d|j]\n"
                    "-h\tHelp dialog\n"
                    "-d\tDelimeter for default output style.\n"
                    "-j\tUse JSON output style\n");
                return EXIT_SUCCESS;
                break;
            case 'j':
                print_json = 1;
                break;
            default:
                break;
        }
    }

    guint owner_id;
    gchar *bus_name = "org.freedesktop.Notifications";
    introspection = g_dbus_node_info_new_for_xml(INTROSPECTION_XML, NULL);

    owner_id = g_bus_own_name(G_BUS_TYPE_SESSION, bus_name, G_BUS_NAME_OWNER_FLAGS_NONE,
        bus_acquired, name_acquired, name_lost, NULL, NULL);
    main_loop = g_main_loop_new(NULL, FALSE);

    guint signal_term = g_unix_signal_add(SIGTERM, stop_main_loop, NULL);
    guint signal_int = g_unix_signal_add(SIGINT, stop_main_loop, NULL);

    g_main_loop_run(main_loop);

    g_source_remove(signal_term);
    g_source_remove(signal_int);

    g_clear_pointer(&main_loop, g_main_loop_unref);
    g_clear_pointer(&introspection, g_dbus_node_info_unref);

    g_bus_unown_name(owner_id);
    return EXIT_SUCCESS;
}

