package ext.deployit.slib.validator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Pattern;

import com.xebialabs.deployit.plugin.api.reflect.PropertyKind;
import com.xebialabs.deployit.plugin.api.validation.ApplicableTo;
import com.xebialabs.deployit.plugin.api.validation.Rule;
import com.xebialabs.deployit.plugin.api.validation.ValidationContext;

@Retention(RetentionPolicy.RUNTIME)
@Rule(clazz = NotMustacheValidator.Validator.class, type = "notmustache")
@ApplicableTo({PropertyKind.STRING, PropertyKind.MAP_STRING_STRING, PropertyKind.LIST_OF_STRING, PropertyKind.SET_OF_STRING})
@Target(ElementType.FIELD)
public @interface NotMustacheValidator {
    String DEFAULT_MESSAGE = "Value '%s' not resolved by the dictionary";

    String message() default DEFAULT_MESSAGE;

    public static class Validator implements com.xebialabs.deployit.plugin.api.validation.Validator<Object> {
        private final String pattern = "^(?!\\{\\{).+(?!\\}\\})$";
        private String message = DEFAULT_MESSAGE;

        @Override
        @SuppressWarnings({"unchecked"})
        public void validate(Object pValue, ValidationContext pContext) {
            // PropertyKind.STRING
            if (pValue instanceof String) {
                validateString((String) pValue, pContext);
            }
            // PropertyKind.MAP_STRING_STRING
            else if (pValue instanceof Map<?, ?>) {
                Map<String, String> lMap = (Map<String, String>) pValue;
                for (Entry<String, String> lEntry : lMap.entrySet()) {
                    validateString(lEntry.getValue(), pContext);
                }
            }
            // PropertyKind.LIST_OF_STRING
            else if (pValue instanceof List<?>) {
                List<String> lList = (List<String>) pValue;
                for (String lString : lList) {
                    validateString(lString, pContext);
                }
            }
        }

        private void validateString(String pString, ValidationContext pContext) {
            if (!Pattern.compile(pattern).matcher(pString).matches()) {
                pContext.error(message, pString);
            }
        }
    }
}