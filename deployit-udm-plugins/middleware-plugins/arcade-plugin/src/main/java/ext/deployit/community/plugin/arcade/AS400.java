package ext.deployit.community.plugin.arcade;

import com.xebialabs.deployit.plugin.api.udm.Metadata;
import com.xebialabs.deployit.plugin.api.udm.Property;
import com.xebialabs.deployit.plugin.api.udm.base.BaseContainer;

@Metadata(
        root = Metadata.ConfigurationItemRoot.INFRASTRUCTURE,
        description = "An AS400")
public class AS400 extends BaseContainer {

    @Property
    private String adresse;

    @Property
    private String username;

    @Property(password = true)
    private String password;

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(final String adresse) {
        this.adresse = adresse;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(final String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(final String password) {
        this.password = password;
    }
}
