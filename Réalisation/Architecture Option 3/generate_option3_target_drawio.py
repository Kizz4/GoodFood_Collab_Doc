from pathlib import Path
import xml.etree.ElementTree as ET
from xml.sax.saxutils import escape


BASE_DIR = Path(__file__).resolve().parent
REALISATION_DIR = BASE_DIR.parent
SCHEMA_DIR = next(
    (path for path in REALISATION_DIR.iterdir() if path.is_dir() and path.name.lower().startswith("sch")),
    REALISATION_DIR / "Schéma",
)
OUT = SCHEMA_DIR / "Nouveau" / "To-Be_Good_Food_Option3.drawio"
NOTES = BASE_DIR / "03_schema_physique_option3_notes.md"

PHASES = {
    "phase1": ("#B45309", "#F59E0B"),
    "phase2": ("#047857", "#34D399"),
    "phase3": ("#0369A1", "#38BDF8"),
    "phase4": ("#6D28D9", "#A78BFA"),
}


class Drawio:
    def __init__(self):
        self.root = ET.Element(
            "mxfile",
            host="app.diagrams.net",
            modified="2026-03-16T00:00:00.000Z",
            agent="Codex",
            version="24.7.17",
        )
        self.diagram = ET.SubElement(self.root, "diagram", id="option3", name="Option 3")
        self.model = ET.SubElement(
            self.diagram,
            "mxGraphModel",
            dx="1800",
            dy="1200",
            grid="1",
            gridSize="10",
            guides="1",
            tooltips="1",
            connect="1",
            arrows="1",
            fold="1",
            page="1",
            pageScale="1",
            pageWidth="2600",
            pageHeight="1800",
            math="0",
            shadow="0",
        )
        self.r = ET.SubElement(self.model, "root")
        ET.SubElement(self.r, "mxCell", id="0")
        ET.SubElement(self.r, "mxCell", id="1", parent="0")
        self.i = 2

    def _id(self):
        value = str(self.i)
        self.i += 1
        return value

    def cell(
        self,
        value="",
        style="",
        x=0,
        y=0,
        w=100,
        h=40,
        parent="1",
        vertex="1",
        edge=False,
        source=None,
        target=None,
        points=None,
    ):
        cid = self._id()
        attrs = {"id": cid, "value": value, "style": style, "parent": parent}
        if edge:
            attrs["edge"] = "1"
            if source:
                attrs["source"] = source
            if target:
                attrs["target"] = target
        else:
            attrs["vertex"] = vertex
        cell = ET.SubElement(self.r, "mxCell", **attrs)
        geometry = ET.SubElement(
            cell,
            "mxGeometry",
            {
                "x": str(x),
                "y": str(y),
                "width": str(w),
                "height": str(h),
                "as": "geometry",
            },
        )
        if edge and points:
            arr = ET.SubElement(geometry, "Array", {"as": "points"})
            for px, py in points:
                ET.SubElement(arr, "mxPoint", x=str(px), y=str(py))
        return cid

    def save(self, path: Path):
        ET.indent(self.root)
        ET.ElementTree(self.root).write(path, encoding="utf-8", xml_declaration=True)


def box_style(fill, stroke, font=13, align="center", rounded=1, font_color="#F8FAFC"):
    return (
        f"rounded={rounded};whiteSpace=wrap;html=1;fillColor={fill};strokeColor={stroke};"
        f"strokeWidth=2;fontColor={font_color};fontSize={font};align={align};"
        "verticalAlign=middle;fontStyle=1;"
    )


def zone_style(fill, stroke, font=16):
    return (
        f"rounded=1;arcSize=18;whiteSpace=wrap;html=1;fillColor={fill};strokeColor={stroke};"
        f"strokeWidth=2;fontColor=#E5E7EB;fontSize={font};fontStyle=1;verticalAlign=top;spacingTop=12;"
    )


def note_style(fill, stroke, font_color="#0F172A"):
    return (
        f"rounded=1;whiteSpace=wrap;html=1;fillColor={fill};strokeColor={stroke};strokeWidth=2;"
        f"fontColor={font_color};fontSize=11;align=left;verticalAlign=middle;spacing=10;"
    )


def edge_style(color, width=2, dashed=False):
    style = (
        f"edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;"
        f"strokeColor={color};strokeWidth={width};endArrow=block;endFill=1;"
    )
    if dashed:
        style += "dashed=1;dashPattern=6 4;"
    return style


def label_style():
    return (
        "rounded=1;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#CBD5E1;"
        "fontColor=#0F172A;fontSize=11;align=center;verticalAlign=middle;"
    )


def add_service(drawio, title, tech, phase_key, x, y, w=180, h=86):
    fill, stroke = PHASES[phase_key]
    value = (
        f"<b>{title}</b>"
        f"<div style=\"font-size:11px;color:#E2E8F0;font-weight:normal\">{tech}</div>"
    )
    return drawio.cell(
        value,
        box_style(fill, stroke, font=14, align="left") + "spacingLeft=18;",
        x,
        y,
        w,
        h,
    )


def add_db(drawio, title, tech, phase_key, x, y, w=170, h=58):
    fill, stroke = PHASES[phase_key]
    value = f"<b>{title}</b><div style=\"font-size:11px;color:#E2E8F0;font-weight:normal\">{tech}</div>"
    return drawio.cell(
        value,
        box_style(fill, stroke, font=13, align="left") + "spacingLeft=18;",
        x,
        y,
        w,
        h,
    )


d = Drawio()

# Background
d.cell("", "shape=rect;whiteSpace=wrap;html=1;fillColor=#0B1220;strokeColor=#0B1220;", 0, 0, 2600, 1800)

title = d.cell(
    "GoodFood To-Be - Option 3 - Cible finale microservices",
    "text;html=1;strokeColor=none;fillColor=none;fontColor=#E2E8F0;fontSize=24;fontStyle=1;align=center;verticalAlign=middle;",
    560,
    20,
    1500,
    40,
)
subtitle = d.cell(
    "Le runtime cible est full microservices. Les couleurs racontent l'ordre de construction de la trajectoire.",
    "text;html=1;strokeColor=none;fillColor=none;fontColor=#94A3B8;fontSize=13;align=center;verticalAlign=middle;",
    520,
    58,
    1580,
    24,
)

# Main zones
channels = d.cell("Canaux & utilisateurs", zone_style("#1E293B", "#FB923C"), 30, 120, 320, 1240)
edge_zone = d.cell("Edge Azure & sécurité", zone_style("#102A43", "#38BDF8"), 390, 120, 460, 280)
trajectory_zone = d.cell("Trajectoire & légende", zone_style("#2A1E3A", "#A78BFA"), 870, 120, 500, 280)
runtime = d.cell("AKS - Runtime microservices final", zone_style("#0F2A1F", "#22C55E"), 390, 430, 980, 500)
data = d.cell("Données & observabilité", zone_style("#1F1B3A", "#A78BFA"), 390, 960, 980, 340)
externals = d.cell("SI externe & partenaires", zone_style("#241A0F", "#84CC16"), 1410, 120, 1120, 1240)

# Channels and users
web = d.cell(
    "<b>Application Web</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">React<br/>client + franchise + back-office</div>",
    box_style("#0F172A", "#64748B", font=14, align="left") + "spacingLeft=20;",
    70,
    190,
    240,
    95,
)
mobile_client = d.cell(
    "<b>App Mobile Client</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">React Native</div>",
    box_style("#0F172A", "#64748B", font=14, align="left") + "spacingLeft=20;",
    70,
    340,
    240,
    85,
)
mobile_courier = d.cell(
    "<b>App Mobile Livreur</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">React Native</div>",
    box_style("#0F172A", "#64748B", font=14, align="left") + "spacingLeft=20;",
    70,
    470,
    240,
    85,
)
users1 = d.cell(
    "<b>Clients</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">commande, paiement, suivi</div>",
    box_style("#111827", "#94A3B8", font=13, align="left") + "spacingLeft=20;",
    70,
    660,
    240,
    75,
)
users2 = d.cell(
    "<b>Franchisés / Restaurateurs</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">menus, promotions, préparation</div>",
    box_style("#111827", "#94A3B8", font=13, align="left") + "spacingLeft=20;",
    70,
    770,
    240,
    75,
)
users3 = d.cell(
    "<b>Back-office</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">compta, communication, IT N1</div>",
    box_style("#111827", "#94A3B8", font=13, align="left") + "spacingLeft=20;",
    70,
    880,
    240,
    75,
)
users4 = d.cell(
    "<b>Livreurs</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">missions et preuve de livraison</div>",
    box_style("#111827", "#94A3B8", font=13, align="left") + "spacingLeft=20;",
    70,
    990,
    240,
    75,
)

# Edge and security
ingress = d.cell(
    "<b>Ingress / TLS</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">AKS Ingress + cert-manager</div>",
    box_style("#082F49", "#38BDF8", font=14, align="left") + "spacingLeft=20;",
    430,
    180,
    180,
    90,
)
gateway = d.cell(
    "<b>API Gateway</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">YARP</div>",
    box_style("#0C4A6E", "#38BDF8", font=14, align="left") + "spacingLeft=20;",
    650,
    180,
    170,
    90,
)
keycloak = d.cell(
    "<b>Plateforme IAM</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">Keycloak</div>",
    box_style("#14532D", "#22C55E", font=14, align="left") + "spacingLeft=20;",
    520,
    305,
    190,
    55,
)
consul = d.cell(
    "<b>Discovery / Health</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">Consul + probes</div>",
    box_style("#581C87", "#C084FC", font=14, align="left") + "spacingLeft=20;",
    725,
    305,
    150,
    55,
)

# Trajectory legend
trajectory_note = d.cell(
    "<b>Lecture</b><div style=\"font-size:11px;color:#334155;font-weight:normal\">Le schéma montre l'état final microservices.<br/>La couleur des services indique l'ordre de construction recommandé.</div>",
    note_style("#F8FAFC", "#94A3B8"),
    900,
    165,
    440,
    70,
)

legend_y = 255
for idx, (title_text, desc_text, phase_key) in enumerate(
    [
        ("Étape 1", "noyau critique dans le premier modulith : compte, catalogue, commande", "phase1"),
        ("Étape 2", "modulith complet avant séparation : réclamations, franchise", "phase2"),
        ("Étape 3", "services extraits en priorité : paiement, livraison, notification, intégration", "phase3"),
        ("Étape 4", "briques de distribution finale : orchestration et cible complètement distribuée", "phase4"),
    ]
):
    fill, stroke = PHASES[phase_key]
    d.cell("", f"rounded=1;whiteSpace=wrap;html=1;fillColor={fill};strokeColor={stroke};strokeWidth=2;", 905, legend_y + idx * 38, 22, 22)
    d.cell(
        f"<b>{title_text}</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">{desc_text}</div>",
        "text;html=1;strokeColor=none;fillColor=none;fontColor=#E2E8F0;fontSize=12;align=left;verticalAlign=middle;",
        940,
        legend_y + idx * 36 - 2,
        390,
        28,
    )

flow_note = d.cell(
    "<b>Couleurs des flux</b><div style=\"font-size:11px;color:#334155;font-weight:normal\">Bleu : HTTP / accès front<br/>Orange : événements asynchrones<br/>Violet : données, cache et logs<br/>Rouge : paiement en ligne<br/>Vert : intégrations SI</div>",
    note_style("#F8FAFC", "#94A3B8"),
    900,
    420 - 120,
    440,
    92,
)

# Runtime services
customer = add_service(d, "Service Compte Client", "ASP.NET Core", "phase1", 430, 490)
catalogue = add_service(d, "Service Catalogue", "ASP.NET Core", "phase1", 640, 490)
order = add_service(d, "Service Commande", "ASP.NET Core", "phase1", 850, 490)

complaint = add_service(d, "Service Réclamations", "ASP.NET Core", "phase2", 430, 615)
franchise = add_service(d, "Service Franchise", "ASP.NET Core", "phase2", 640, 615)

payment = add_service(d, "Service Paiement", "ASP.NET Core", "phase3", 430, 740)
delivery = add_service(d, "Service Livraison", "Node.js / TypeScript", "phase3", 640, 740)
notification = add_service(d, "Service Notification", "ASP.NET Core Worker/API", "phase3", 850, 740)
integration = add_service(d, "Integration Hub / ACL", "ASP.NET Core Worker", "phase3", 1060, 615, w=250, h=96)
saga = add_service(d, "Orchestrateur Saga", "MassTransit StateMachine", "phase4", 1060, 740, w=250, h=86)

rabbit = d.cell(
    "<b>RabbitMQ</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">events + async</div>",
    box_style("#9A3412", "#FB923C", font=14, align="left") + "spacingLeft=20;",
    1060,
    490,
    250,
    80,
)

# Data and observability
customer_db = add_db(d, "DB Compte Client", "PostgreSQL", "phase1", 420, 1010)
catalogue_db = add_db(d, "DB Catalogue", "PostgreSQL", "phase1", 610, 1010)
order_db = add_db(d, "DB Commande", "PostgreSQL", "phase1", 800, 1010)
complaint_db = add_db(d, "DB Réclamations", "PostgreSQL", "phase2", 990, 1010)
franchise_db = add_db(d, "DB Franchise", "PostgreSQL", "phase2", 1180, 1010)

payment_db = add_db(d, "DB Paiement", "PostgreSQL", "phase3", 420, 1090)
delivery_db = add_db(d, "DB Livraison", "MongoDB", "phase3", 610, 1090)
notification_db = add_db(d, "DB Notification", "PostgreSQL", "phase3", 800, 1090)
integration_db = add_db(d, "DB Intégration", "PostgreSQL", "phase3", 990, 1090)
saga_db = add_db(d, "DB Saga", "PostgreSQL", "phase4", 1180, 1090)

auth_db = d.cell(
    "<b>DB IAM</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">PostgreSQL</div>",
    box_style("#1E1B4B", "#A78BFA", font=13, align="left") + "spacingLeft=18;",
    420,
    1180,
    170,
    58,
)
redis = d.cell(
    "<b>Redis</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">cache</div>",
    box_style("#78350F", "#F59E0B", font=14, align="left") + "spacingLeft=20;",
    610,
    1180,
    170,
    58,
)
elk = d.cell(
    "<b>ELK</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">logs & observabilité</div>",
    box_style("#4C1D95", "#A855F7", font=14, align="left") + "spacingLeft=20;",
    800,
    1180,
    170,
    58,
)
devops_note = d.cell(
    "<b>Déploiement</b><div style=\"font-size:11px;color:#0F172A;font-weight:normal\">Dev local : Docker Compose<br/>Staging / Prod : AKS + HPA / KEDA<br/>La couleur de phase ne décrit pas l'environnement.</div>",
    note_style("#E0F2FE", "#38BDF8"),
    995,
    1170,
    355,
    72,
)

# External systems
m365 = d.cell(
    "<b>Microsoft 365</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">messagerie métier</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1450,
    180,
    250,
    75,
)
dyn = d.cell(
    "<b>Dynamics 365</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">ERP finance / RH / CRM / stock</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1730,
    180,
    250,
    75,
)
sage = d.cell(
    "<b>Sage Trésorerie</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">rapprochements et trésorerie</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1450,
    310,
    250,
    75,
)
bnb = d.cell(
    "<b>BNB / PSP</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">paiement en ligne + EBICS</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1730,
    310,
    250,
    75,
)
pos = d.cell(
    "<b>TP System / Nouveau POS</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">caisse, TPE, terrain</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1450,
    440,
    250,
    75,
)
maps = d.cell(
    "<b>Google Maps</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">ETA & cartographie</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1730,
    440,
    250,
    75,
)
sendgrid = d.cell(
    "<b>SendGrid</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">email transactionnel</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1450,
    570,
    250,
    75,
)
twilio = d.cell(
    "<b>Twilio</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">SMS</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1730,
    570,
    250,
    75,
)
firebase = d.cell(
    "<b>Firebase FCM</b><div style=\"font-size:11px;color:#CBD5E1;font-weight:normal\">push mobile</div>",
    box_style("#111827", "#94A3B8", font=14, align="left") + "spacingLeft=20;",
    1450,
    700,
    250,
    75,
)
external_note = d.cell(
    "<b>Décision d'architecture</b><div style=\"font-size:11px;color:#0F172A;font-weight:normal\">Le schéma vise la cible runtime finale en microservices.<br/>La trajectoire modulith-first reste visible grâce au code couleur des services.</div>",
    note_style("#F8FAFC", "#64748B"),
    1450,
    840,
    530,
    88,
)

# Edges
for source, target, label, points, color, width in [
    (users1, web, "web", [(330, 697), (360, 697), (360, 230), (430, 230)], "#60A5FA", 3),
    (users1, mobile_client, "mobile", [(330, 697), (360, 697), (360, 382), (430, 382)], "#60A5FA", 3),
    (users2, web, "web", [(330, 807), (370, 807), (370, 248), (430, 248)], "#60A5FA", 3),
    (users3, web, "back-office", [(330, 917), (380, 917), (380, 266), (430, 266)], "#60A5FA", 3),
    (users4, mobile_courier, "mobile", [(330, 1027), (360, 1027), (360, 512), (430, 512)], "#60A5FA", 3),
    (web, ingress, "HTTPS", [(330, 230), (370, 230), (370, 220), (430, 220)], "#60A5FA", 3),
    (mobile_client, ingress, "HTTPS", [(330, 382), (370, 382), (370, 236), (430, 236)], "#60A5FA", 3),
    (mobile_courier, ingress, "HTTPS", [(330, 512), (370, 512), (370, 252), (430, 252)], "#60A5FA", 3),
    (ingress, gateway, "route", [(610, 220), (632, 220), (632, 220), (650, 220)], "#38BDF8", 3),
    (gateway, keycloak, "OIDC/JWT", [(735, 270), (735, 320), (625, 320)], "#38BDF8", 3),
    (gateway, consul, "discovery", [(760, 270), (760, 332), (800, 332)], "#A78BFA", 2),
    (gateway, customer, "/accounts", [(735, 270), (735, 270), (520, 270), (520, 490)], "#38BDF8", 2),
    (gateway, catalogue, "/catalog", [(780, 270), (780, 325), (730, 325), (730, 490)], "#38BDF8", 2),
    (gateway, order, "/orders", [(820, 270), (910, 270), (910, 490)], "#38BDF8", 3),
    (gateway, complaint, "/complaints", [(690, 270), (690, 350), (520, 350), (520, 615)], "#38BDF8", 2),
    (gateway, franchise, "/franchise", [(805, 270), (805, 360), (730, 360), (730, 615)], "#38BDF8", 2),
    (gateway, payment, "/payments", [(820, 270), (520, 270), (520, 740)], "#38BDF8", 3),
    (gateway, delivery, "/delivery", [(820, 270), (730, 270), (730, 740)], "#38BDF8", 3),
    (order, customer, "client", [(850, 533), (810, 533), (810, 533), (610, 533)], "#38BDF8", 2),
    (order, catalogue, "catalog", [(850, 545), (825, 545), (825, 533), (820, 533)], "#38BDF8", 2),
    (customer, customer_db, "SQL", [(520, 576), (520, 1010)], "#A78BFA", 2),
    (catalogue, catalogue_db, "SQL", [(730, 576), (730, 1010)], "#A78BFA", 2),
    (order, order_db, "SQL", [(940, 576), (885, 576), (885, 1010)], "#A78BFA", 2),
    (complaint, complaint_db, "SQL", [(520, 701), (1075, 701), (1075, 1010)], "#A78BFA", 2),
    (franchise, franchise_db, "SQL", [(730, 701), (1265, 701), (1265, 1010)], "#A78BFA", 2),
    (payment, payment_db, "SQL", [(520, 826), (520, 1090)], "#A78BFA", 2),
    (delivery, delivery_db, "Mongo", [(730, 826), (730, 1090)], "#A78BFA", 2),
    (notification, notification_db, "SQL", [(940, 826), (885, 826), (885, 1090)], "#A78BFA", 2),
    (integration, integration_db, "SQL", [(1185, 711), (1075, 711), (1075, 1090)], "#A78BFA", 2),
    (saga, saga_db, "SQL", [(1185, 826), (1265, 826), (1265, 1090)], "#A78BFA", 2),
    (keycloak, auth_db, "SQL", [(615, 360), (505, 360), (505, 1180)], "#A78BFA", 2),
    (catalogue, redis, "cache", [(685, 576), (685, 1180)], "#F59E0B", 2),
    (order, rabbit, "events", [(1030, 533), (1030, 530), (1060, 530)], "#F97316", 3),
    (complaint, rabbit, "events", [(610, 658), (980, 658), (980, 545), (1060, 545)], "#F97316", 2),
    (franchise, rabbit, "events", [(820, 658), (995, 658), (995, 560), (1060, 560)], "#F97316", 2),
    (payment, rabbit, "events", [(610, 783), (980, 783), (980, 575), (1060, 575)], "#F97316", 3),
    (delivery, rabbit, "events", [(820, 783), (1010, 783), (1010, 590), (1060, 590)], "#F97316", 3),
    (notification, rabbit, "consume", [(940, 783), (1015, 783), (1015, 600), (1060, 600)], "#F97316", 2),
    (integration, rabbit, "consume", [(1060, 655), (1030, 655), (1030, 610), (1060, 610)], "#F97316", 2),
    (saga, rabbit, "saga bus", [(1060, 770), (1035, 770), (1035, 620), (1060, 620)], "#F97316", 2),
    (payment, bnb, "pay", [(610, 783), (1370, 783), (1370, 347), (1730, 347)], "#EF4444", 3),
    (delivery, maps, "ETA", [(820, 783), (1370, 783), (1370, 477), (1730, 477)], "#60A5FA", 2),
    (notification, sendgrid, "email", [(1030, 783), (1370, 783), (1370, 607), (1450, 607)], "#8B5CF6", 2),
    (notification, twilio, "sms", [(1030, 798), (1370, 798), (1370, 607), (1730, 607)], "#8B5CF6", 2),
    (notification, firebase, "push", [(1030, 812), (1370, 812), (1370, 737), (1450, 737)], "#8B5CF6", 2),
    (integration, dyn, "ERP", [(1310, 647), (1380, 647), (1380, 217), (1730, 217)], "#22C55E", 3),
    (integration, sage, "finance", [(1310, 665), (1380, 665), (1380, 347), (1450, 347)], "#22C55E", 2),
    (integration, m365, "mailboxes", [(1310, 683), (1380, 683), (1380, 217), (1450, 217)], "#22C55E", 2),
    (integration, pos, "POS", [(1310, 701), (1380, 701), (1380, 477), (1450, 477)], "#22C55E", 2),
    (integration, bnb, "EBICS", [(1310, 719), (1390, 719), (1390, 367), (1730, 367)], "#22C55E", 2),
    (order, elk, "logs", [(940, 533), (940, 1180), (885, 1180)], "#A855F7", 2),
    (payment, elk, "logs", [(610, 783), (610, 1240), (885, 1240)], "#A855F7", 2),
    (delivery, elk, "logs", [(820, 783), (820, 1230), (885, 1230)], "#A855F7", 2),
    (integration, elk, "logs", [(1185, 711), (1185, 1220), (970, 1220)], "#A855F7", 2),
    (gateway, elk, "logs", [(820, 225), (930, 225), (930, 1180)], "#A855F7", 2),
]:
    edge_id = d.cell("", edge_style(color, width=width, dashed=(color == "#A855F7")), edge=True, source=source, target=target, points=points)
    if label:
        mid = points[len(points) // 2]
        d.cell(escape(label), label_style(), mid[0] - 35, mid[1] - 14, 90, 24)

# Save diagram
OUT.parent.mkdir(parents=True, exist_ok=True)
d.save(OUT)

with open(NOTES, "w", encoding="utf-8") as handle:
    handle.write("# Schéma physique cible Option 3\n\n")
    handle.write("## Positionnement visé\n")
    handle.write("- gauche : canaux et utilisateurs ;\n")
    handle.write("- haut centre : edge Azure, gateway, IAM et légende de trajectoire ;\n")
    handle.write("- centre : runtime AKS décrit dans son état final microservices ;\n")
    handle.write("- bas centre : bases de données, cache et observabilité ;\n")
    handle.write("- droite : SI externe, partenaires et fournisseurs techniques.\n\n")
    handle.write("## Code couleur des étapes\n")
    handle.write("- orange : noyau critique du premier modulith (`Compte Client`, `Catalogue`, `Commande`) ;\n")
    handle.write("- vert : domaines ajoutés pour obtenir le modulith complet (`Réclamations`, `Franchise`) ;\n")
    handle.write("- bleu : services extraits en priorité pendant la transition (`Paiement`, `Livraison`, `Notification`, `Integration Hub / ACL`) ;\n")
    handle.write("- violet : briques de distribution finale (`Orchestrateur Saga` et bases associées).\n\n")
    handle.write("## Couleurs des flux\n")
    handle.write("- bleu : accès HTTP depuis le web/mobile et appels synchrones ;\n")
    handle.write("- orange : événements asynchrones sur le broker ;\n")
    handle.write("- violet : données, cache et logs ;\n")
    handle.write("- rouge : paiement en ligne ;\n")
    handle.write("- vert : intégrations ERP, trésorerie, messagerie, POS et EBICS.\n\n")
    handle.write("## Message du schéma\n")
    handle.write(
        "Le schéma vise maintenant la cible runtime finale de l'option 3, c'est-à-dire une plateforme complètement découpée en microservices. "
        "La logique modulith-first n'a pas disparu : elle est racontée par la couleur des services, qui indique dans quel ordre les domaines sont construits puis extraits.\n"
    )
